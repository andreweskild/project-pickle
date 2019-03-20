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
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: items.map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Material(
                  elevation: value == item.value ? 6.0 : 0.0,
                  color: value == item.value ? Theme.of(context).buttonColor : Theme.of(context).unselectedWidgetColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: !(value == item.value) ? Theme.of(context).dividerColor : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  shadowColor: Theme.of(context).splashColor.withAlpha(60),
                  child: InkWell(
                    onTap: () => onChanged(item.value),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Center(
                        child: IconTheme(
                          data: value == item.value ? Theme.of(context).accentIconTheme :
                          Theme.of(context).iconTheme,
                          child: DefaultTextStyle(
                              style: Theme.of(context).accentTextTheme.button,
                              child: item.child
                          ),
                        )
                    )
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}