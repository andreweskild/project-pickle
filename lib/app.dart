import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';

import 'package:project_pickle/pages/pixel_editor_page.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/reducer.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/widgets/common/slider_thumb_shape.dart';

final store = Store<AppState>(
  stateReducer,
  initialState: AppState(
    canvasWidth: 32,
    canvasHeight: 32,
    drawingBuffer: PixelBuffer(32, 32),
    primaryColor: HSLColor.fromAHSL(1.0, 1.0, 1.0, 1.0),
    secondaryColor: HSLColor.fromAHSL(1.0, 100.0, 1.0, 0.5),
    layers: <PixelCanvasLayer>[
      PixelCanvasLayer(
        name: 'Layer 1',
        width: 32,
        height: 32,
      )
    ],
    palette: <HSLColor>[
      HSLColor.fromAHSL(1.0, 34.0, 0.5, 0.4),
      HSLColor.fromAHSL(1.0, 25.0, 0.8, 0.4),
      HSLColor.fromAHSL(1.0, 155.4, 0.6, 0.6),
      HSLColor.fromAHSL(1.0, 300.8, 0.9, 0.7),
    ],
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Project pickle',
        theme: ThemeData(
            accentColor: const Color(0xFFB0EF63),
            cardColor: const Color(0xFFFFFFFF),
            bottomAppBarColor: const Color(0xFFC4FB81),
            buttonColor: const Color(0xFFC4FB81),
            dividerColor: Colors.black.withAlpha(25),
            primarySwatch:
                MaterialColor(const Color(0xFFD7FFA7).value, const <int, Color>{
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
            splashColor: const Color(0x9986C040),
            highlightColor: const Color(0x99B0EF63),
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
            accentIconTheme: Theme.of(context).accentIconTheme.copyWith(
              color: const Color(0xFF5A990D),
            ),
            buttonTheme: ButtonTheme.of(context).copyWith(
              minWidth: 12.0,
            ),
            scaffoldBackgroundColor: const Color(0xFFF1F1F1),
            textTheme: Theme.of(context).textTheme.copyWith(
                  title: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                  button: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.grey.shade800,
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
          unselectedWidgetColor: const Color(0xFFFBFBFB),
          primaryIconTheme: Theme.of(context).iconTheme.copyWith(
            color: const Color(0xFF5A990D),
          )
        ),

        // GBA Theme 2
        // theme: new ThemeData(
        //   accentColor: new Color(0xFF8bac0f),
        //   primarySwatch: new MaterialColor(0xFF346856, const <int, Color> {50 : const Color(0xFFFFF8E1), 100 : const Color(0xFFFFECB3), 200 : const Color(0xFFFFE082), 300 : const Color(0xFFFFD54F), 400 : const Color(0xFFFFCA28), 500 : const Color(0xFFFFC107), 600 : const Color(0xFFFFB300), 700 : const Color(0xFFFFA000), 800 : const Color(0xFFFF8F00), 900 : const Color(0xFFFF6F00)}),
        //   splashColor: new Color(0xFF88c070),
        //   highlightColor: new Color(0xFFe0f8d0),
        //   accentTextTheme: Theme.of(context).accentTextTheme.copyWith(
        //     button: Theme.of(context).accentTextTheme.button.copyWith(color: new Color(0xFF346856))
        //   )
        // ),

        home: PixelEditorPage(name: 'Pickle Editor'),
      ),
    );
  }
}
