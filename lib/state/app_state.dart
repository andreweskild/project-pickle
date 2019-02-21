import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';
import 'package:project_pickle/tools/base_tool.dart';

enum ShapeMode {
  Rectangle,
  Circle,
  Triangle,
}

class AppState {
  AppState({
    this.canvasDirty = false,
    this.layersDirty = false,
    this.canvasHistory,
    this.canvasFuture,
    this.canvasWidth,
    this.canvasHeight,
    this.canvasScale = 1.0,
    this.darkMode = false,
    this.currentTool,
    this.activeColorIndex = 0,
    this.drawingBuffer,
    this.eraserRemoveCounter = 0,
    this.layerNamingCounter = 1,
    @required this.layers,
    @required this.palette,
    this.selectionPath,
    this.toolOpacity = 1.0,
    this.toolSize = 1.0,
    this.toolShape = ShapeMode.Rectangle,
    this.shapeFilled = false,
    @required TickerProvider tickerProvider
  }) {
    _tickerProvider = tickerProvider;
  }

  AppState copyWith({
    int activeColorIndex,
    bool canvasDirty,
    Queue<PixelLayerList> canvasHistory,
    Queue<PixelLayerList> canvasFuture,
    double canvasScale,
    int canvasWidth,
    int canvasHeight,
    bool darkMode,
    PixelBuffer drawingBuffer,
    int eraserRemoveCounter,
    int currentLayerIndex,
    BaseTool currentTool,
    bool layersDirty,
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
      darkMode: darkMode ?? this.darkMode,
      drawingBuffer: drawingBuffer ?? this.drawingBuffer,
      eraserRemoveCounter: eraserRemoveCounter ?? this.eraserRemoveCounter,
      currentTool: currentTool ?? this.currentTool,
      layersDirty: layersDirty ?? this.layersDirty,
      layerNamingCounter: layerNamingCounter ?? this.layerNamingCounter,
      layers: layers ?? this.layers,
      palette: palette ?? this.palette,
      selectionPath: selectionPath ?? this.selectionPath,
      toolOpacity: toolOpacity ?? this.toolOpacity,
      toolSize: toolSize ?? this.toolSize,
      toolShape: toolShape ?? this.toolShape,
      shapeFilled: shapeFilled ?? this.shapeFilled,
      tickerProvider: this._tickerProvider,
    );
  }

  bool canvasDirty;
  Queue<PixelLayerList> canvasHistory;
  Queue<PixelLayerList> canvasFuture;
  int layerNamingCounter;
  bool layersDirty;
  int canvasWidth;
  int canvasHeight;
  double canvasScale;
  bool darkMode;
  int activeColorIndex;
  PixelBuffer drawingBuffer;
  PixelLayer get currentLayer => layers.activeLayer;
  BaseTool currentTool;
  PixelLayerList layers;
  var palette = <Color>[];
  Path selectionPath;
  TickerProvider _tickerProvider;
  get tickerProvider => _tickerProvider;
  double toolSize;
  double toolOpacity;
  ShapeMode toolShape;
  bool shapeFilled;
  int eraserRemoveCounter;


  Color get activeColor =>
      palette[activeColorIndex];

}



