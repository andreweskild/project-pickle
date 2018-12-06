import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';
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
    this.canvasDirty = false,
    this.canvasHistory,
    this.canvasFuture,
    this.canvasWidth,
    this.canvasHeight,
    this.canvasScale = 1.0,
    this.currentTool,
    this.activeColorIndex = 0,
    this.activeColorType = ColorType.Primary,
    this.drawingBuffer,
    this.eraserRemoveCounter = 0,
    @required this.primaryColor,
    @required this.secondaryColor,
    this.layerNamingCounter = 1,
    @required this.layers,
    @required this.palette,
    this.selectionPath,
    this.toolOpacity = 1.0,
    this.toolSize = 1.0,
    this.toolShape = ShapeMode.Rectangle,
    this.shapeFilled = false,
  });

  AppState copyWith({
    int activeColorIndex,
    bool canvasDirty,
    Queue<PixelLayerList> canvasHistory,
    Queue<PixelLayerList> canvasFuture,
    double canvasScale,
    int canvasWidth,
    int canvasHeight,
    PixelBuffer drawingBuffer,
    int eraserRemoveCounter,
    ColorType activeColorType,
    Color primaryColor,
    Color secondaryColor,
    int currentLayerIndex,
    BaseTool currentTool,
    int layerNamingCounter,
    PixelLayerList layers,
    List<Color> palette,
    Path selectionPath,
    double toolOpacity,
    double toolSize,
    ShapeMode toolShape,
    bool shapeFilled,
  }) {
    return AppState(
      activeColorIndex: activeColorIndex ?? this.activeColorIndex,
      canvasDirty: canvasDirty ?? this.canvasDirty,
      canvasHistory: canvasHistory ?? this.canvasHistory,
      canvasFuture: canvasFuture ?? this.canvasFuture,
      canvasScale: canvasScale ?? this.canvasScale,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      activeColorType: activeColorType ?? this.activeColorType,
      drawingBuffer: drawingBuffer ?? this.drawingBuffer,
      eraserRemoveCounter: eraserRemoveCounter ?? this.eraserRemoveCounter,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      currentTool: currentTool ?? this.currentTool,
      layerNamingCounter: layerNamingCounter ?? this.layerNamingCounter,
      layers: layers ?? this.layers,
      palette: palette ?? this.palette,
      selectionPath: selectionPath ?? this.selectionPath,
      toolOpacity: toolOpacity ?? this.toolOpacity,
      toolSize: toolSize ?? this.toolSize,
      toolShape: toolShape ?? this.toolShape,
      shapeFilled: shapeFilled ?? this.shapeFilled,
    );
  }

  bool canvasDirty;
  Queue<PixelLayerList> canvasHistory;
  Queue<PixelLayerList> canvasFuture;
  int layerNamingCounter;
  int canvasWidth;
  int canvasHeight;
  double canvasScale;
  int activeColorIndex;
  ColorType activeColorType;
  PixelBuffer drawingBuffer;
  Color primaryColor;
  Color secondaryColor;
  PixelLayer get currentLayer => layers.activeLayer;
  BaseTool currentTool;
  PixelLayerList layers;
  var palette = <Color>[];
  Path selectionPath;
  double toolSize;
  double toolOpacity;
  ShapeMode toolShape;
  bool shapeFilled;
  int eraserRemoveCounter;


  Color get activeColor =>
      palette[activeColorIndex];

}



