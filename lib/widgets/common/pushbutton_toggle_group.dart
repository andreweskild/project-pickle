import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


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
    @required this.value,
  });

  final List<PushbuttonToggle<T>> items;
  final ValueChanged<T> onChanged;
  final T value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).unselectedWidgetColor,
          ),
          child: Row(
            children: items.map<Widget>((item) {
              return Expanded(
                child: Material(
                  elevation: 0.0,
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => onChanged(item.value),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease,
                            opacity: value == item.value ? 1.0 : 0.0,
                            child: Material(
                              elevation: 6.0,
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              shadowColor: Theme.of(context).splashColor.withAlpha(60),
                            ),
                          ),
                        ),
                        Center(
                          child: IconTheme(
                            data: value == item.value ? Theme.of(context).accentIconTheme :
                              Theme.of(context).iconTheme,
                            child: DefaultTextStyle(
                              style: Theme.of(context).accentTextTheme.button,
                              child: item.child
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}