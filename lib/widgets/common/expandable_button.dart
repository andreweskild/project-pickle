// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kPanelHeaderCollapsedHeight = 40.0;
const double _kPanelHeaderExpandedHeight = 40.0;

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt
        && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

/// Signature for the callback that's called when an [ExpandableButton] is
/// expanded or collapsed.
///
/// The position of the panel within an [ExpandableButtonList] is given by
/// [panelIndex].
typedef ExpandableButtonCallback = void Function(int panelIndex, bool isExpanded);

/// Signature for the callback that's called when the header of the
/// [ExpandableButton] needs to rebuild.
typedef ExpandableButtonHeaderBuilder = Widget Function(BuildContext context, bool isExpanded);

/// A material expansion panel. It has a header and a body and can be either
/// expanded or collapsed. The body of the panel is only visible when it is
/// expanded.
///
/// Expansion panels are only intended to be used as children for
/// [ExpandableButtonList].
///
/// See also:
///
///  * [ExpandableButtonList]
///  * <https://material.google.com/components/expansion-panels.html>
class ExpandableButton {
  /// Creates an expansion panel to be used as a child for [ExpandableButtonList].
  ///
  /// The [headerBuilder], [body], and [isExpanded] arguments must not be null.
  ExpandableButton({
    @required this.headerBuilder,
    @required this.body,
    this.isExpanded = false,
  }) : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null);

  /// The widget builder that builds the expansion panels' header.
  final ExpandableButtonHeaderBuilder headerBuilder;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;


}

/// An expansion panel that allows for radio-like functionality.
///
/// A unique identifier [value] must be assigned to each panel.
class ExpandableButtonRadio extends ExpandableButton {

  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor. The
  /// [headerBuilder], [body], [value] must not be null.
  ExpandableButtonRadio({
    @required this.value,
    @required ExpandableButtonHeaderBuilder headerBuilder,
    @required Widget body,
  }) : assert(value != null),
        super(body: body, headerBuilder: headerBuilder);

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

/// A material expansion panel list that lays out its children and animates
/// expansions.
///
/// See also:
///
///  * [ExpandableButton]
///  * <https://material.google.com/components/expansion-panels.html>
class ExpandableButtonList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const ExpandableButtonList({
    Key key,
    this.children = const <ExpandableButton>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
  }) : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null,
        super(key: key);

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open.
  /// The expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] and [animationDuration]
  /// arguments must not be null. The [children] objects must be instances
  /// of [ExpandableButtonRadio].
  const ExpandableButtonList.radio({
    Key key,
    List<ExpandableButtonRadio> children = const <ExpandableButtonRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
  }) : children = children, // ignore: prefer_initializing_formals
        assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<ExpandableButton> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the index of the
  /// to-be-expanded panel in the list and whether the panel is currently
  /// expanded or not.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpandableButtonCallback expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [ExpandableButtonList.radio]
  /// constructor.)
  final Object initialOpenPanelValue;

  @override
  State<StatefulWidget> createState() => _ExpandableButtonListState();
}

class _ExpandableButtonListState extends State<ExpandableButtonList> {
  ExpandableButtonRadio _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All object identifiers are not unique!');
      for (ExpandableButtonRadio child in widget.children) {
        if (widget.initialOpenPanelValue != null &&
            child.value == widget.initialOpenPanelValue)
          _currentOpenPanel = child;
      }
    }
  }

  @override
  void didUpdateWidget(ExpandableButtonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All object identifiers are not unique!');
      for (ExpandableButtonRadio newChild in widget.children) {
        if (widget.initialOpenPanelValue != null &&
            newChild.value == widget.initialOpenPanelValue)
          _currentOpenPanel = newChild;
      }
    } else if(oldWidget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (ExpandableButtonRadio child in widget.children) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final ExpandableButtonRadio radioWidget = widget.children[index];
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCallback != null)
      widget.expansionCallback(index, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final ExpandableButtonRadio pressedChild = widget.children[index];

      for (int childIndex = 0; childIndex < widget.children.length; childIndex += 1) {
        final ExpandableButtonRadio child = widget.children[childIndex];
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value)
          widget.expansionCallback(childIndex, false);
      }
      _currentOpenPanel = isExpanded ? null : pressedChild;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    const EdgeInsets kExpandedEdgeInsets = EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight
    );

    for (int index = 0; index < widget.children.length; index += 1) {

      final ExpandableButton child = widget.children[index];
      final Row header = Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index) ? kExpandedEdgeInsets : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kPanelHeaderCollapsedHeight),
                child: child.headerBuilder(
                  context,
                  _isChildExpanded(index),
                ),
              ),
            ),
          ),
        ],
      );

      items.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: child.isExpanded ? Theme.of(context).dividerColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: <Widget>[
                Material(
                  elevation: child.isExpanded ? 6.0 : 0.0,
                  color: child.isExpanded ? Theme.of(context).buttonColor : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                  shadowColor: Theme.of(context).buttonColor.withAlpha(100),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    child: MergeSemantics(child: header),
                    onTap: () => _handlePressed(_isChildExpanded(index), index),
                  )
                ),
                AnimatedCrossFade(
                  firstChild: Container(height: 0.0),
                  secondChild: child.body,
                  firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: widget.animationDuration,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: items,
      ),
    );
  }
}