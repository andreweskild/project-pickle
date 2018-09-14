import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/pages/pixel_editor_page.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/reducer.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/widgets/common/slider_thumb_shape.dart';

final store = Store<AppState>(
  stateReducer,
  initialState: AppState(
    currentColor: HSLColor.fromAHSL(1.0, 1.0, 1.0, 1.0),
    layers: <PixelCanvasLayer>[PixelCanvasLayer(
      name: 'Layer 1',
      width: 32,
      height: 32,
    )],
    palette: <HSLColor>[
      HSLColor.fromAHSL(1.0, 34.0, 0.5, 0.4),
      HSLColor.fromAHSL(1.0, 25.0, 0.8, 0.4),
      HSLColor.fromAHSL(1.0, 155.4, 0.6, 0.6),
      HSLColor.fromAHSL(1.0, 300.8, 0.9, 0.7),
    ],
    previewLayer: PixelCanvasLayer(width: 32, height: 32),
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
          accentColor: Colors.grey.shade700,
          cardColor: Colors.grey.shade100,
          buttonColor: Colors.grey.shade400,
          dividerColor: Colors.grey.shade400,
          primarySwatch: MaterialColor(Colors.grey.shade100.value, const <int, Color> {50 : const Color(0xFFFFF8E1), 100 : const Color(0xFFFFECB3), 200 : const Color(0xFFFFE082), 300 : const Color(0xFFFFD54F), 400 : const Color(0xFFFFCA28), 500 : const Color(0xFFFFC107), 600 : const Color(0xFFFFB300), 700 : const Color(0xFFFFA000), 800 : const Color(0xFFFF8F00), 900 : const Color(0xFFFF6F00)}),
          splashColor: Colors.black38,
          highlightColor: Colors.black54,
          accentTextTheme: Theme.of(context).accentTextTheme.copyWith(
            button: Theme.of(context).accentTextTheme.button.copyWith(color: Colors.white),
          ),
          buttonTheme: ButtonTheme.of(context).copyWith(
            minWidth: 12.0,
          ),
          scaffoldBackgroundColor: Colors.grey.shade400,
          textTheme: Theme.of(context).textTheme.copyWith(
            title: Theme.of(context).textTheme.title.copyWith(
              fontSize: 16.0,
            ),
          ),
          splashFactory: InkRipple.splashFactory,
          sliderTheme: Theme.of(context).sliderTheme.copyWith(
            activeTrackColor: Colors.grey.shade600,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.grey.shade400,
            thumbShape: SliderThumbShape(),
            overlayColor: Colors.grey.shade600,
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

        home: PixelEditorPage(
          name: 'Pickle Editor'
        ),
      ),
    );
  }
}