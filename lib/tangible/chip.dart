import 'package:flutter/material.dart';

import 'shadows.dart';

class FilterChip extends StatelessWidget {
  /// Create a chip that acts like a checkbox.
  ///
  /// The [selected], [label], and [clipBehavior] arguments must not be null.
  /// The [pressElevation] and [elevation] must be null or non-negative.
  /// Typically, [pressElevation] is greater than [elevation].
  const FilterChip({
    Key key,
    @required this.label,
    this.avatar,
    this.selected = false,
    @required this.onSelected,
    this.tooltip,
  }) : assert(selected != null),
        assert(label != null),
        super(key: key);

  final Widget avatar;
  final Widget label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final String tooltip;

  bool get isEnabled => onSelected != null;

  @override
  Widget build(BuildContext context) {

    Widget _paddedAvatar;

    if(avatar != null) {
      _paddedAvatar = Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: avatar,
      );
    }

    assert(debugCheckHasMaterial(context));
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        shadows: selected ? kColoredShadowMap(Theme.of(context).accentColor)[6] : null,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: Theme.of(context).accentIconTheme.color,
          size: 20.0,
        ),
        child: RawChip(
          avatar: selected ? _paddedAvatar : null,
          label: label,
          labelStyle: Theme.of(context).textTheme.button.copyWith(
            color: selected ? Theme.of(context).accentTextTheme.button.color : Theme.of(context).textTheme.button.color
          ),
          labelPadding: EdgeInsets.zero,
          onSelected: onSelected,
          pressElevation: 0.0,
          showCheckmark: false,
          selected: selected,
          tooltip: tooltip,
          shape: StadiumBorder(
              side: BorderSide(
                color: Theme.of(context).dividerColor.withAlpha(25),
              )
          ),
          clipBehavior: Clip.antiAlias,
          backgroundColor: Theme.of(context).buttonColor,
          disabledColor: Colors.red,
          selectedColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          isEnabled: isEnabled,
          elevation: 0.0,
        ),
      ),
    );
  }
}