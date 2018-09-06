import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/common/toggle_button.dart';
import 'package:project_pickle/widgets/common/vertical_divider.dart';

/// A material design toggle button.
///
/// Used to select between a number of mutually exclusive values. When one toggle
/// button in a group is selected, the other toggle buttons in the group cease to
/// be selected. The values are of type `T`, the type parameter of the [ToggleButton]
/// class. Enums are commonly used for this purpose.
///
/// The toggle button itself does not maintain any state. Instead, when the state
/// of the toggle button changes, the widget calls the [onChanged] callback.
/// Most widget that use a toggle button will listen for the [onChanged]
/// callback and rebuild the toggle button with a new [groupValue] to update the
/// visual appearance of the toggle button.
///
/// See also:
///
///  * <https://material.google.com/components/selection-controls.html#selection-controls-radio-button>
class ToggleButtonGroup<T> extends StatefulWidget {
  /// Creates a material design toggle button.
  ///
  /// The toggle button itself does not maintain any state. Instead, when the
  /// toggle button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a toggle button will listen for the [onChanged] callback
  /// and rebuild the toggle button with a new [groupValue] to update the visual
  /// appearance of the toggle button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the toggle button is
  ///   selected.
  /// * [onChanged] is called when the user selects this toggle button.
  const ToggleButtonGroup({
    Key key,
    @required this.actions,
    @required this.groupValue,
    @required this.onChanged,
    this.borderRadius = BorderRadius.zero,
    this.side = BorderSide.none,
    this.activeColor,
  }) : super(key: key);

  final List<ToggleButtonAction<T>> actions;

  /// The currently selected value for this group of toggle buttons.
  ///
  /// This toggle button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  /// Called when the user selects this toggle button.
  ///
  /// The toggle button passes [value] as a parameter to this callback. The toggle
  /// button does not actually change state until the parent widget rebuilds the
  /// toggle button with the new [groupValue].
  ///
  /// If null, the toggle button will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// new ToggleButton<Shape>(
  ///   icon: Icon(Icons.brightness)
  ///   value: Shape.circle,
  ///   groupValue: _shape,
  ///   onChanged: (Shape newValue) {
  ///     setState(() {
  ///       _shape = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T> onChanged;

  /// The color to use when this toggle button is selected.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color activeColor;

  final BorderRadius borderRadius;

  final BorderSide side;

  @override
  _ToggleButtonGroupState<T> createState() => new _ToggleButtonGroupState<T>();
}

class _ToggleButtonGroupState<T> extends State<ToggleButtonGroup<T>> with TickerProviderStateMixin {
//  bool get _enabled => widget.onChanged != null;
//
//  Color _getInactiveColor(ThemeData themeData) {
//    return _enabled ? themeData.unselectedWidgetColor : themeData.disabledColor;
//  }
//
//  void _handleChanged(bool selected) {
//    if (selected)
//      widget.onChanged(widget.value);
//  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
      child: Material(
        color: themeData.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
          side: widget.side,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            widget.actions.length,
            (index) {
                var action = widget.actions[index];
                return SizedBox(
                  height: 48.0,
                  width: 48.0,
                  child: FlatButton(
                    padding: const EdgeInsets.all(8.0),
                    child: action.icon,
                    shape: Border.all(
                      color: Colors.black,
                    ),
                    onPressed: (){},
                  ),
                );
//              else {
//                return VerticalDivider();
//              }
            }
          )
        ),
      ),
    );
  }
}