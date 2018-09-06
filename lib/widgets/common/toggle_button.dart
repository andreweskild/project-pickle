import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
class ToggleButtonAction<T> {
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
  const ToggleButtonAction({
    @required this.icon,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged
  });

  /// The icon to display for this toggle button.
  final Widget icon;

  /// The value represented by this toggle button.
  final T value;

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
}

//class _ToggleButtonActionState<T> extends State<ToggleButtonAction<T>> with TickerProviderStateMixin {
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
//
//  @override
//  Widget build(BuildContext context) {
//    final ThemeData themeData = Theme.of(context);
//    return FlatButton(
//      child: widget.icon,
//      onPressed: () => widget.onChanged(widget.value)
//    );
//  }
//}