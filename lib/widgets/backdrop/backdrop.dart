import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Widget frontLayer;
  final String title;
  final List<Widget> menuItems;

  const Backdrop({
    @required this.frontLayer,
    @required this.title,
    this.menuItems,
  })  : assert(frontLayer != null),
        assert(title != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    
    final _appBarWidgets = <Widget>[
      new Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            color: Colors.black,
            onPressed: _toggleBackdropLayerVisibility,
          ),
          new Expanded(
            child: new TextField(
              controller: new TextEditingController(text: widget.title),
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.center_focus_weak),
            color: Colors.black,
            onPressed: (){},
          ),
        ],
      ),
    ]..addAll(widget.menuItems);


    const double menuItemHeight = 48.0;
    final Size layerSize = constraints.biggest;
    Animation<Rect> menuRevealAnimation = RectTween(
      begin: Rect.fromLTRB(0.0, menuItemHeight * _appBarWidgets.length, layerSize.width, layerSize.height),
      end: Rect.fromLTRB(0.0, menuItemHeight, layerSize.width, layerSize.height)
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      fit: StackFit.expand,
      children: <Widget>[
        new Material(
          color: Colors.amberAccent,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(new Radius.circular(8.0)),
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _appBarWidgets,
          ),
        ),
        RelativePositionedTransition(
          rect: menuRevealAnimation,
          size: layerSize,
          child: new Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(new Radius.circular(8.0)),
            ),
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildStack);
  }
}