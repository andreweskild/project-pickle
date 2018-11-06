import 'package:flutter/material.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/tools/base_tool.dart';

// enum for differentiating between whether the primary color or secondary color is active.
enum ColorType {
  Primary,
  Secondary
}

enum ShapeMode {
  Rectangle,
  Circle,
  Triangle,
}

class AppState {
  AppState({
    this.canvasScale = 1.0,
    this.currentTool,
    this.activeColorType = ColorType.Primary,
    @required this.primaryColor,
    @required this.secondaryColor,
    this.currentLayerIndex = 0,
    this.layerNamingCounter = 1,
    @required this.layers,
    this.leftDrawerSizeMode = DrawerSizeMode.Normal,
    @required this.palette,
    this.rightDrawerSizeMode = DrawerSizeMode.Normal,
    this.selectionPath,
    this.toolOpacity = 1.0,
    this.toolSize = 1.0,
    this.toolShape = ShapeMode.Rectangle,
    this.shapeFilled = false,
  });

  AppState copyWith({
    double canvasScale,
    ColorType activeColorType,
    HSLColor primaryColor,
    HSLColor secondaryColor,
    int currentLayerIndex,
    BaseTool currentTool,
    int layerNamingCounter,
    List<PixelCanvasLayer> layers,
    DrawerSizeMode leftDrawerSizeMode,
    List<HSLColor> palette,
    PixelCanvasLayer previewLayer,
    DrawerSizeMode rightDrawerSizeMode,
    Path selectionPath,
    double toolOpacity,
    double toolSize,
    ShapeMode toolShape,
    bool shapeFilled,
  }) {
    return AppState(
      canvasScale: canvasScale ?? this.canvasScale,
      activeColorType: activeColorType ?? this.activeColorType,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      currentTool: currentTool ?? this.currentTool,
      layerNamingCounter: layerNamingCounter ?? this.layerNamingCounter,
      layers: layers ?? this.layers,
      leftDrawerSizeMode: leftDrawerSizeMode ?? this.leftDrawerSizeMode,
      palette: palette ?? this.palette,
      rightDrawerSizeMode: rightDrawerSizeMode ?? this.rightDrawerSizeMode,
      selectionPath: selectionPath ?? this.selectionPath,
      toolOpacity: toolOpacity ?? this.toolOpacity,
      toolSize: toolSize ?? this.toolSize,
      toolShape: toolShape ?? this.toolShape,
      shapeFilled: shapeFilled ?? this.shapeFilled,
    );
  }

  int layerNamingCounter;
  double canvasScale;
  ColorType activeColorType;
  HSLColor get currentColor =>
      (activeColorType == ColorType.Primary) ? primaryColor : secondaryColor;
  HSLColor primaryColor;
  HSLColor secondaryColor;
  PixelCanvasLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  BaseTool currentTool;
  List<PixelCanvasLayer> layers;
  DrawerSizeMode leftDrawerSizeMode;
  var palette = new List<HSLColor>();
  DrawerSizeMode rightDrawerSizeMode;
  Path selectionPath;
  double toolSize;
  double toolOpacity;
  ShapeMode toolShape;
  bool shapeFilled;
}



