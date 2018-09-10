import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/tools/base_tool.dart';

class AppState {
  AppState({
    this.canvasScale = 1.0,
    this.currentTool,
    @required this.currentColor,
    this.currentLayerIndex = 0,
    this.layerNamingCounter = 1,
    @required this.layers,
    this.leftDrawerSizeMode = DrawerSizeMode.Normal,
    @required this.palette,
    @required this.previewLayer,
    this.rightDrawerSizeMode = DrawerSizeMode.Normal,
    this.selectionPath,
  });

  AppState copyWith({
    double canvasScale,
    HSLColor currentColor,
    int currentLayerIndex,
    BaseTool currentTool,
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
      currentTool: currentTool ?? this.currentTool,
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
  BaseTool currentTool;
  List<PixelCanvasLayer> layers;
  DrawerSizeMode leftDrawerSizeMode;
  final PixelCanvasLayer previewLayer;
  var palette = new List<HSLColor>();
  DrawerSizeMode rightDrawerSizeMode;
  Path selectionPath;
}



