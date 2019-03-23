import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/common/slider_thumb_shape.dart';

theme(BuildContext context, bool darkMode) {
  if (darkMode) {
    return ThemeData.dark().copyWith(
      accentColor: const Color(0xFFB0EF63),
      accentTextTheme: Theme.of(context).accentTextTheme.copyWith(
        button: Theme.of(context)
            .accentTextTheme
            .button
            .copyWith(color: const Color(0xFF5A990D)),
        title: Theme.of(context)
            .accentTextTheme
            .title
            .copyWith(color: const Color(0xFF5A990D))
            .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      primaryColor: const Color(0xFFD7FFA7),
      primaryColorDark: Colors.red,
      accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
        color: const Color(0xFF5A990D),
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        minWidth: 12.0,
      ),
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.white,
        size: 18.0,
      ),
      buttonColor: const Color(0xFFC4FB81),
      disabledColor: const Color(0xFFA2D95E),
      bottomAppBarColor: const Color(0xFFC4FB81),
      scaffoldBackgroundColor: const Color(0xFF57505A),
      cardColor: const Color(0xFF756D79),
      unselectedWidgetColor: const Color(0xFF645D67),
      splashColor: const Color(0x9986C040),
      highlightColor: const Color(0x99B0EF63),
      textTheme: Theme.of(context).textTheme.copyWith(
          title: Theme.of(context).textTheme.title.copyWith(
            color: Colors.white,
            fontSize: 16.0,
          ),
          button: Theme.of(context).textTheme.button.copyWith(
            color: Colors.grey.shade50,
          ),
          body1: Theme.of(context).textTheme.body1.copyWith(
            color: Colors.grey.shade50,
          ),
      ),
      splashFactory: InkRipple.splashFactory,
      sliderTheme: Theme.of(context).sliderTheme.copyWith(
        activeTrackColor: const Color(0xFFC4FB81),
        activeTickMarkColor: Colors.black.withAlpha(25),
        inactiveTrackColor: const Color(0xFFA2D95E),
        inactiveTickMarkColor: Colors.black.withAlpha(25),
        thumbColor: Colors.white,
        thumbShape: SliderThumbShape(),
        overlayColor: const Color(0xFF8FC84A),
      ),
      toggleableActiveColor: const Color(0xFF86C040),
      primaryIconTheme: Theme.of(context).iconTheme.copyWith(
        color: const Color(0xFF5A990D),
      )
    );
  } else {
    return ThemeData(
      brightness: Brightness.light,
      accentColor: const Color(0xFFB0EF63),
      cardColor: const Color(0xFFFFFFFF),
      bottomAppBarColor: const Color(0xFFC4FB81),
      buttonColor: const Color(0xFFFFFFFF),
      disabledColor: Colors.black38,
      dividerColor: Colors.black.withAlpha(40),
      primarySwatch:
        MaterialColor(const Color(0xFFC4FB81).value, const <int, Color>{
          50: const Color(0xFFD7FFA7),
          100: const Color(0xFFC4FB81),
          200: const Color(0xFFFFE082),
          300: const Color(0xFFFFD54F),
          400: const Color(0xFFFFCA28),
          500: const Color(0xFFFFC107),
          600: const Color(0xFFFFB300),
          700: const Color(0xFFFFA000),
          800: const Color(0xFFFF8F00),
          900: const Color(0xFFFF6F00)
        }),
      splashColor: const Color(0xFFAFF35B),
      highlightColor: const Color(0xFFDEFEB7),
      accentTextTheme: Theme.of(context).accentTextTheme.copyWith(
        button: Theme.of(context)
            .accentTextTheme
            .button
            .copyWith(color: const Color(0xFF5A990D))
            .copyWith(fontSize: 18.0),
        title: Theme.of(context)
            .accentTextTheme
            .title
            .copyWith(color: const Color(0xFF5A990D))
            .copyWith(fontSize: 18.0),
      ),
      accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
        color: const Color(0xFF5A990D),
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        minWidth: 12.0,
        height: 64.0,
      ),
      chipTheme: ChipTheme.of(context).copyWith(

      ),
      iconTheme: IconTheme.of(context).copyWith(
        color: const Color(0xFF666666),
      ),
      scaffoldBackgroundColor: const Color(0xFFDEDBE0),
      textTheme: Theme.of(context).textTheme.copyWith(
          title: Theme.of(context).textTheme.title.copyWith(
            color: const Color(0xFF666666),
            fontSize: 18.0,
          ),
          button: Theme.of(context).textTheme.button.copyWith(
            color: const Color(0xFF666666),
            fontSize: 16.0,
          )
      ),
      splashFactory: InkRipple.splashFactory,
      sliderTheme: Theme.of(context).sliderTheme.copyWith(
        activeTrackColor: const Color(0xFFC4FB81),
        activeTickMarkColor: Colors.black.withAlpha(25),
        inactiveTrackColor: const Color(0xFFA2D95E),
        inactiveTickMarkColor: Colors.black.withAlpha(25),
        thumbColor: Colors.white,
        thumbShape: SliderThumbShape(),
        overlayColor: const Color(0xFF8FC84A),
      ),
      toggleableActiveColor: const Color(0xFF86C040),
      unselectedWidgetColor: const Color(0xFFF5F4F6),
      primaryIconTheme: Theme.of(context).iconTheme.copyWith(
        color: const Color(0xFF666666),
      )
    );
  }
}