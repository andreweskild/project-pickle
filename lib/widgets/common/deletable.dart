import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

const Curve _kResizeTimeCurve = Interval(0.4, 1.0, curve: Curves.ease);
const double _kMinFlingVelocity = 700.0;
const double _kMinFlingVelocityDelta = 400.0;
const double _kFlingVelocityScale = 1.0 / 300.0;
const double _kDismissThreshold = 1.0;
const double _kRevealAmount = 48.0;

/// Signature used by [Deletable] to indicate that it has been dismissed in
/// the given `direction`.
///
/// Used by [Deletable.onDeleted].
typedef DismissDirectionCallback = void Function(DismissDirection direction);

/// The direction in which a [Deletable] can be dismissed.
enum DismissDirection {
  /// The [Deletable] can be dismissed by dragging either up or down.
  vertical,

  /// The [Deletable] can be dismissed by dragging either left or right.
  horizontal,

  /// The [Deletable] can be dismissed by dragging in the reverse of the
  /// reading direction (e.g., from right to left in left-to-right languages).
  endToStart,

  /// The [Deletable] can be dismissed by dragging in the reading direction
  /// (e.g., from left to right in left-to-right languages).
  startToEnd,

  /// The [Deletable] can be dismissed by dragging up only.
  up,

  /// The [Deletable] can be dismissed by dragging down only.
  down
}

/// A widget that can be dismissed by dragging in the indicated [direction].
///
/// Dragging or flinging this widget in the [DismissDirection] causes the child
/// to slide out of view. Following the slide animation, if [resizeDuration] is
/// non-null, the Deletable widget animates its height (or width, whichever is
/// perpendicular to the dismiss direction) to zero over the [resizeDuration].
///
/// Backgrounds can be used to implement the "leave-behind" idiom. If a background
/// is specified it is stacked behind the Deletable's child and is exposed when
/// the child moves.
///
/// The widget calls the [onDeleted] callback either after its size has
/// collapsed to zero (if [resizeDuration] is non-null) or immediately after
/// the slide animation (if [resizeDuration] is null). If the Deletable is a
/// list item, it must have a key that distinguishes it from the other items and
/// its [onDeleted] callback must remove the item from the list.
class Deletable extends StatefulWidget {
  /// Creates a widget that can be dismissed.
  ///
  /// The [key] argument must not be null because [Deletable]s are commonly
  /// used in lists and removed from the list when dismissed. Without keys, the
  /// default behavior is to sync widgets based on their index in the list,
  /// which means the item after the dismissed item would be synced with the
  /// state of the dismissed item. Using keys causes the widgets to sync
  /// according to their keys and avoids this pitfall.
  const Deletable({
    @required Key key,
    @required this.child,
    this.background,
    this.secondaryBackground,
    this.onResize,
    this.onDeleted,
    this.direction = DismissDirection.horizontal,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const <DismissDirection, double>{},
    this.movementDuration = const Duration(milliseconds: 200),
    this.crossAxisEndOffset = 0.0,
  }) : assert(key != null),
        assert(secondaryBackground != null ? background != null : true),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// A widget that is stacked behind the child. If secondaryBackground is also
  /// specified then this widget only appears when the child has been dragged
  /// down or to the right.
  final Widget background;

  /// A widget that is stacked behind the child and is exposed when the child
  /// has been dragged up or to the left. It may only be specified when background
  /// has also been specified.
  final Widget secondaryBackground;

  /// Called when the widget changes size (i.e., when contracting before being dismissed).
  final VoidCallback onResize;

  /// Called when the widget has been dismissed, after finishing resizing.
  final DismissDirectionCallback onDeleted;

  /// The direction in which the widget can be dismissed.
  final DismissDirection direction;

  /// The amount of time the widget will spend contracting before [onDeleted] is called.
  ///
  /// If null, the widget will not contract and [onDeleted] will be called
  /// immediately after the widget is dismissed.
  final Duration resizeDuration;

  /// The offset threshold the item has to be dragged in order to be considered
  /// dismissed.
  ///
  /// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% towards one direction to be considered
  /// dismissed. Clients can define different thresholds for each dismiss
  /// direction.
  ///
  /// Flinging is treated as being equivalent to dragging almost to 1.0, so
  /// flinging can dismiss an item past any threshold less than 1.0.
  ///
  /// See also [direction], which controls the directions in which the items can
  /// be dismissed. Setting a threshold of 1.0 (or greater) prevents a drag in
  /// the given [DismissDirection] even if it would be allowed by the
  /// [direction] property.
  final Map<DismissDirection, double> dismissThresholds;

  /// Defines the duration for card to dismiss or to come back to original position if not dismissed.
  final Duration movementDuration;

  /// Defines the end offset across the main axis after the card is dismissed.
  ///
  /// If non-zero value is given then widget moves in cross direction depending on whether
  /// it is positive or negative.
  final double crossAxisEndOffset;

  @override
  _DeletableState createState() => _DeletableState();
}

enum _FlingGestureKind { none, forward, reverse }

class _DeletableState extends State<Deletable> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin { // ignore: MIXIN_INFERENCE_INCONSISTENT_MATCHING_CLASSES
  @override
  void initState() {
    super.initState();
    
    _moveController = AnimationController(duration: widget.movementDuration, vsync: this)
      ..addStatusListener(_handleDismissStatusChanged);
    _updateMoveAnimation();

    contentWidget = buildContentNormal();
  }

  

  AnimationController _moveController;
  Animation<Offset> _moveAnimation;

  Animation<double> _responseSizeAnimation;

  AnimationController _resizeController;
  Animation<double> _resizeAnimation;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;
  Size _sizePriorToCollapse;
  Size _sizePriorToDrag;
  double _inkResponseSize;
  OverlayEntry feedbackWidget;
  Widget contentWidget;

  @override
  bool get wantKeepAlive => _moveController?.isAnimating == true || _resizeController?.isAnimating == true;

  @override
  void dispose() {
    _moveController.dispose();
    _resizeController?.dispose();
    super.dispose();
  }

  bool get _directionIsXAxis {
    return widget.direction == DismissDirection.horizontal
        || widget.direction == DismissDirection.endToStart
        || widget.direction == DismissDirection.startToEnd;
  }

  DismissDirection _extentToDirection(double extent) {
    if (extent == 0.0)
      return null;
    if (_directionIsXAxis) {
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          return extent < 0 ? DismissDirection.startToEnd : DismissDirection.endToStart;
        case TextDirection.ltr:
          return extent > 0 ? DismissDirection.startToEnd : DismissDirection.endToStart;
      }
      assert(false);
      return null;
    }
    return extent > 0 ? DismissDirection.down : DismissDirection.up;
  }

  DismissDirection get _dismissDirection => _extentToDirection(_dragExtent);

  bool get _isActive {
    return _dragUnderway || _moveController.isAnimating;
  }

  double get _overallDragAxisExtent {
    final Size size = context.size;
    return _directionIsXAxis ? size.height : size.height;
  }

  OverlayEntry _buildFeedbackWidget(BuildContext context) {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position.top,
          left: position.left,
          child: SizedBox(
            width: button.size.width,
            height: button.size.height,
            child: SlideTransition(
              position: _moveAnimation,
              child: widget.child
            ),
          ),
        );
      }
    );
  }

  Widget buildContentNormal() {
    return widget.child;
  }
  
  Widget buildContentDragging() {
    return SizedBox(
      height: _sizePriorToDrag.height,
      width: _sizePriorToDrag.width,
      child: Material(
        clipBehavior: Clip.antiAlias,
        elevation: 0.0,
        color: Color(0xFFFFA6B1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: FractionallySizedBox(
            alignment: (widget.direction == DismissDirection.startToEnd) ? Alignment.centerLeft : 
              Alignment.centerRight,
            widthFactor: _kRevealAmount / _sizePriorToDrag.width,
            child: Stack(
              children: <Widget>[
                Center(
                  child: UnconstrainedBox(
                    child: SizedOverflowBox(
                      size: Size.square(_kRevealAmount * _sizePriorToDrag.height / _sizePriorToDrag.width),
                      child: ScaleTransition(
                        scale: _responseSizeAnimation,
                        child: FadeTransition(
                          opacity: _responseSizeAnimation,
                          child: SizedBox(
                            height: _sizePriorToDrag.height * 1.5,
                            width: _sizePriorToDrag.height * 1.5,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color(0xFFFF485E),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Icon(Icons.delete_outline, color: Colors.white),
                )
              ],
            ),
          )
      ),
    );
  }

  void _handleDragStart(BuildContext context, DragStartDetails details) {
    _sizePriorToDrag = context.size;
    contentWidget = buildContentDragging();
    feedbackWidget = _buildFeedbackWidget(context);

    _dragUnderway = true;
    if (_moveController.isAnimating) {
      _dragExtent = _moveController.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
    Navigator.of(context).overlay.insert(feedbackWidget);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController.isAnimating)
      return;

    final double delta = details.primaryDelta;
    final double oldDragExtent = _dragExtent;
    switch (widget.direction) {
      case DismissDirection.horizontal:
      case DismissDirection.vertical:
        _dragExtent += delta;
        break;

      case DismissDirection.up:
        if (_dragExtent + delta < 0)
          _dragExtent += delta;
        break;

      case DismissDirection.down:
        if (_dragExtent + delta > 0)
          _dragExtent += delta;
        break;

      case DismissDirection.endToStart:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta > 0)
              _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta < 0)
              _dragExtent += delta;
            break;
        }
        break;

      case DismissDirection.startToEnd:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta < 0)
              _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta > 0)
              _dragExtent += delta;
            break;
        }
        break;
    }
    if(_sizePriorToDrag != null) {
      _inkResponseSize = _sizePriorToDrag.height * _moveController.value;
    }
    else {
      _inkResponseSize = 0.0;
    }
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation = _moveController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: _directionIsXAxis
            ? (_sizePriorToDrag == null) ?
                Offset(end, widget.crossAxisEndOffset) :
                Offset(end * (_kRevealAmount / _sizePriorToDrag.width), widget.crossAxisEndOffset)
            : Offset(widget.crossAxisEndOffset, end),
      ),
    );
    _responseSizeAnimation = _moveController.drive(
      CurveTween(
        curve: Curves.easeInOut
      )
    );
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    assert(widget.direction != null);
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    DismissDirection flingDirection;
    // Verify that the fling is in the generally right direction and fast enough.
    if (_directionIsXAxis) {
      if (vx.abs() - vy.abs() < _kMinFlingVelocityDelta || vx.abs() < _kMinFlingVelocity)
        return _FlingGestureKind.none;
      assert(vx != 0.0);
      flingDirection = _extentToDirection(vx);
    } else {
      if (vy.abs() - vx.abs() < _kMinFlingVelocityDelta || vy.abs() < _kMinFlingVelocity)
        return _FlingGestureKind.none;
      assert(vy != 0.0);
      flingDirection = _extentToDirection(vy);
    }
    assert(_dismissDirection != null);
    if (flingDirection == _dismissDirection)
      return _FlingGestureKind.forward;
    return _FlingGestureKind.reverse;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController.isAnimating)
      return;
    _dragUnderway = false;
    if (_moveController.isCompleted) {
      _moveController.reverse().whenComplete(
        _startResizeAnimation
      );
      return;
    }
    final double flingVelocity = _directionIsXAxis ? details.velocity.pixelsPerSecond.dx : details.velocity.pixelsPerSecond.dy;
    switch (_describeFlingGesture(details.velocity)) {
      case _FlingGestureKind.forward:
        assert(_dragExtent != 0.0);
        assert(!_moveController.isDismissed);
        if ((widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold) >= 1.0) {
          _moveController.reverse();
          break;
        }
        _dragExtent = flingVelocity.sign;
        _moveController.fling(velocity: flingVelocity.abs() * _kFlingVelocityScale);
        break;
      case _FlingGestureKind.reverse:
        assert(_dragExtent != 0.0);
        assert(!_moveController.isDismissed);
        _dragExtent = flingVelocity.sign;
        _moveController.fling(velocity: -flingVelocity.abs() * _kFlingVelocityScale);
        break;
      case _FlingGestureKind.none:
        if (!_moveController.isDismissed) { // we already know it's not completed, we check that above
          if (_moveController.value > (widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold)) {
            _moveController.forward();
          } else {
            _moveController.reverse().whenComplete(
              () {
                setState((){
                  contentWidget = buildContentNormal();
                });
                feedbackWidget.remove();
              } 
            );
          }
        }
        break;
    }
  }

  void _handleDismissStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_dragUnderway)
      _startResizeAnimation();
    updateKeepAlive();
  }

  void _startResizeAnimation() {
    contentWidget = buildContentNormal();
    feedbackWidget.remove();

    assert(_moveController != null);
    // assert(_moveController.isCompleted);
    assert(_resizeController == null);
    assert(_sizePriorToCollapse == null);
    if (widget.resizeDuration == null) {
      if (widget.onDeleted != null) {
        final DismissDirection direction = _dismissDirection;
        assert(direction != null);
        widget.onDeleted(direction);
      }
    } else {
      _resizeController = AnimationController(duration: widget.resizeDuration, vsync: this)
        ..addListener(_handleResizeProgressChanged)
        ..addStatusListener((AnimationStatus status) => updateKeepAlive());
      _resizeController.forward();
      setState(() {
        _sizePriorToCollapse = context.size;
        _resizeAnimation = _resizeController.drive(
          CurveTween(
              curve: _kResizeTimeCurve
          ),
        ).drive(
          Tween<double>(
              begin: 1.0,
              end: 0.0
          ),
        );
      });
    }
  }

  void _handleResizeProgressChanged() {
    if (_resizeController.isCompleted) {
      if (widget.onDeleted != null) {
        final DismissDirection direction = _dismissDirection;
        assert(direction != null);
        widget.onDeleted(direction);
      }
    } else {
      if (widget.onResize != null)
        widget.onResize();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    assert(!_directionIsXAxis || debugCheckHasDirectionality(context));

    
    Widget deletionBackground = SizedBox();
    Widget background = widget.background;
    if (widget.secondaryBackground != null) {
      final DismissDirection direction = _dismissDirection;
      if (direction == DismissDirection.endToStart || direction == DismissDirection.up)
        background = widget.secondaryBackground;
    }

    if (_resizeAnimation != null) {
      // we've been dragged aside, and are now resizing.
      assert(() {
        if (_resizeAnimation.status != AnimationStatus.forward) {
          assert(_resizeAnimation.status == AnimationStatus.completed);
          throw FlutterError(
              'A dismissed Deletable widget is still part of the tree.\n'
                  'Make sure to implement the onDeleted handler and to immediately remove the Deletable\n'
                  'widget from the application once that handler has fired.'
          );
        }
        return true;
      }());


      return SizeTransition(
          sizeFactor: _resizeAnimation,
          axis: _directionIsXAxis ? Axis.vertical : Axis.horizontal,
          child: SizedBox(
              width: _sizePriorToCollapse.width,
              height: _sizePriorToCollapse.height,
              child: widget.child
          )
      );
    }


    // We are not resizing but we may be being dragging in widget.direction.
    if (widget.onDeleted != null) {
      return GestureDetector(
        onHorizontalDragStart: (details) => _directionIsXAxis ? _handleDragStart(context, details) : null,
        onHorizontalDragUpdate: _directionIsXAxis ? _handleDragUpdate : null,
        onHorizontalDragEnd: _directionIsXAxis ? _handleDragEnd : null,
        // onVerticalDragStart: _directionIsXAxis ? null : _handleDragStart,
        onVerticalDragUpdate: _directionIsXAxis ? null : _handleDragUpdate,
        onVerticalDragEnd: _directionIsXAxis ? null : _handleDragEnd,
        behavior: HitTestBehavior.opaque,
        child: contentWidget
      );
    }
    else {
      return contentWidget;
    }

  }
}