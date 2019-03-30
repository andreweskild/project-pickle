import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tangible/tangible.dart';


class _PushbuttonToggleButton extends StatelessWidget {
  _PushbuttonToggleButton({
    Key key,
    @required this.child,
    @required this.onToggle,
    @required this.toggled,
    this.color,
    this.toggledColor,
    this.splashColor,
    this.shadowColor,
    this.highlightColor,
    this.toggledElevation = 6,
  }) : super(key: key);

  final Color color;
  final Color toggledColor;
  final Color splashColor;
  final Color shadowColor;
  final Color highlightColor;
  final int toggledElevation;
  final Widget child;
  final VoidCallback onToggle;
  final bool toggled;


  @override
  Widget build(BuildContext context) {
    final currentColor =              // Color used for background of button
    (toggled) ?
    toggledColor ?? Material.Theme
        .of(context)
        .primaryColor :
    color ?? Material.Theme
        .of(context)
        .cardColor;

    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: toggled ? kColoredShadowMap(shadowColor ?? Material.Theme.of(context).accentColor)[toggledElevation] : null,
          border: Border.all(
            color: toggled ? Colors.transparent : Material.Theme.of(context).dividerColor,
          )
        ),
        child: Material.Material(
          type: Material.MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0.0,
          child: Material.InkWell(
            splashColor: splashColor,
            highlightColor: highlightColor,
            borderRadius: BorderRadius.circular(8.0),
            onTap: onToggle,
            child: IconTheme(
              data: IconThemeData(
                  color: toggled
                      ? Material.Theme
                      .of(context)
                      .accentIconTheme
                      .color
                      : Material.Theme
                      .of(context)
                      .iconTheme
                      .color
              ),
              child: DefaultTextStyle(
                  style: TextStyle(
                      color: toggled
                          ? Material.Theme
                          .of(context)
                          .accentIconTheme
                          .color
                          : Material.Theme
                          .of(context)
                          .iconTheme
                          .color
                  ),
                  child: child
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A Pushbutton with an associated value, and a child that determines the look of
/// the button. To be used in conjunction with [PushbuttonToggleGroup].
class PushbuttonToggle<T> {
  const PushbuttonToggle({
    Key key,
    @required this.child,
    @required this.value,
  });

  final Widget child;
  final T value;
}

/// A group of buttons that allow toggling between a value.
///
/// The 'items' arugment specifies what each of the buttons represents, and how
/// to present it in the group.
///
/// The 'onChanged' argument represents the callback that is called whenever
/// a Pushbutton is toggled. It is up to the user to handle the onChanged callback
/// and state.
///
/// The 'value' argument specifies what current value that the [PushbuttonToggleGroup]
/// represents, and what Pushbutton to highlight.
class PushbuttonToggleGroup<T> extends StatelessWidget {
  PushbuttonToggleGroup({
    @required this.items,
    @required this.onChanged,
    @required this.activeValue,
  });

  final List<PushbuttonToggle<T>> items;
  final ValueChanged<T> onChanged;
  final T activeValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.0,
      child: Row(
        children: items.map<Widget>((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: _PushbuttonToggleButton(
              child: IconTheme(
                data: activeValue == item.value ? Theme.of(context).accentIconTheme :
                Theme.of(context).iconTheme,
                child: DefaultTextStyle(
                  style: Theme.of(context).accentTextTheme.button,
                  child: item.child
                ),
              ),
              onToggle: () => onChanged(item.value),
              toggled: activeValue == item.value
            )
          );
        }).toList(),
      ),
    );
  }
}