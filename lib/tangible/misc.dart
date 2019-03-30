import 'package:flutter/widgets.dart';

class HorizontalSpacer extends StatelessWidget {
  /// Create a fixed size spacer, useful for adding padding between widgets
  /// in rows..
  //
  const HorizontalSpacer({
    Key key,
    this.width = 12.0,
  });

  final double width;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
    );
  }
}