import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/pages/pixel_editor_page.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/reducer.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

final store = new Store<AppState>(
  stateReducer,
  initialState: new AppState(
    currentToolType: ToolType.pencil,
    currentColor: new HSLColor(),
    layers: <PixelCanvasLayer>[PixelCanvasLayer(
      name: 'Layer 1',
      width: 32,
      height: 32,
    )],
    palette: <HSLColor>[
      new HSLColor(h: 1.0, s: 0.5, l: 0.4),
      new HSLColor(h: 0.1, s: 0.8, l: 0.4),
      new HSLColor(h: 0.4, s: 0.6, l: 0.6),
      new HSLColor(h: 0.8, s: 0.9, l: 0.7),
    ],
    previewLayer: PixelCanvasLayer(width: 32, height: 32),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Project pickle',
        
        // GBA Theme 1
        theme: new ThemeData(
          accentColor: Colors.grey.shade700,
          cardColor: Colors.grey.shade100,
          buttonColor: Colors.grey.shade300,
          dividerColor: Colors.black26,
          primarySwatch: new MaterialColor(Colors.grey.shade100.value, const <int, Color> {50 : const Color(0xFFFFF8E1), 100 : const Color(0xFFFFECB3), 200 : const Color(0xFFFFE082), 300 : const Color(0xFFFFD54F), 400 : const Color(0xFFFFCA28), 500 : const Color(0xFFFFC107), 600 : const Color(0xFFFFB300), 700 : const Color(0xFFFFA000), 800 : const Color(0xFFFF8F00), 900 : const Color(0xFFFF6F00)}),
          splashColor: Colors.black38,
          highlightColor: Colors.black26,
          accentTextTheme: Theme.of(context).accentTextTheme.copyWith(
            button: Theme.of(context).accentTextTheme.button.copyWith(color: new Color(0xFF0f380f)),
          ),
          buttonTheme: ButtonTheme.of(context).copyWith(
            minWidth: 12.0,
          ),
          scaffoldBackgroundColor: Colors.grey.shade300,
          textTheme: Theme.of(context).textTheme.copyWith(
            title: Theme.of(context).textTheme.title.copyWith(
              fontSize: 16.0,
            ),
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

        home: new PixelEditorPage(
          name: 'Pickle Editor'
        ),
      ),
    );
  }
}