import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class AppState {
  AppState({
    this.canvasScale = 1.0,
    this.currentToolType = ToolType.pencil,
    @required this.currentColor,
    this.currentLayerIndex = 0,
    this.layerNamingCounter = 1,
    @required this.layers,
    this.leftDrawerSizeMode = DrawerSizeMode.Medium,
    @required this.palette,
    @required this.previewLayer,
    this.rightDrawerSizeMode = DrawerSizeMode.Medium,
    this.selectionPath,
  });

  AppState copyWith({
    double canvasScale,
    HSLColor currentColor,
    int currentLayerIndex,
    ToolType currentToolType,
    int layerNamingCounter,
    List<PixelCanvasLayer> layers,
    DrawerSizeMode leftDrawerSizeMode,
    List<HSLColor> palette,
    PixelCanvasLayer previewLayer,
    DrawerSizeMode rightDrawerSizeMode,
    Path selectionPath,
  }) {
    return AppState(
      canvasScale: canvasScale ?? this.canvasScale,
      currentColor: currentColor ?? this.currentColor,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      currentToolType: currentToolType ?? this.currentToolType,
      layerNamingCounter: layerNamingCounter ?? this.layerNamingCounter,
      layers: layers ?? this.layers,
      leftDrawerSizeMode: leftDrawerSizeMode ?? this.leftDrawerSizeMode,
      palette: palette ?? this.palette,
      previewLayer: previewLayer ?? this.previewLayer,
      rightDrawerSizeMode: rightDrawerSizeMode ?? this.rightDrawerSizeMode,
      selectionPath: selectionPath ?? this.selectionPath,
    );
  }

  int layerNamingCounter;
  double canvasScale;
  HSLColor currentColor;
  PixelCanvasLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  ToolType currentToolType;
  List<PixelCanvasLayer> layers;
  DrawerSizeMode leftDrawerSizeMode;
  final PixelCanvasLayer previewLayer;
  var palette = new List<HSLColor>();
  DrawerSizeMode rightDrawerSizeMode;
  Path selectionPath;
}



