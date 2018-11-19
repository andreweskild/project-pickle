import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
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
    this.activeColorType = ColorType.Primary,
    this.drawingBuffer,
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
    bool canvasDirty,
    Queue<PixelLayerList> canvasHistory,
    Queue<PixelLayerList> canvasFuture,
    double canvasScale,
    int canvasWidth,
    int canvasHeight,
    PixelBuffer drawingBuffer,
    ColorType activeColorType,
    HSLColor primaryColor,
    HSLColor secondaryColor,
    int currentLayerIndex,
    BaseTool currentTool,
    int layerNamingCounter,
    PixelLayerList layers,
    DrawerSizeMode leftDrawerSizeMode,
    List<HSLColor> palette,
    DrawerSizeMode rightDrawerSizeMode,
    Path selectionPath,
    double toolOpacity,
    double toolSize,
    ShapeMode toolShape,
    bool shapeFilled,
  }) {
    return AppState(
      canvasDirty: canvasDirty ?? this.canvasDirty,
      canvasHistory: canvasHistory ?? this.canvasHistory,
      canvasFuture: canvasFuture ?? this.canvasFuture,
      canvasScale: canvasScale ?? this.canvasScale,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      activeColorType: activeColorType ?? this.activeColorType,
      drawingBuffer: drawingBuffer ?? this.drawingBuffer,
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

  bool canvasDirty;
  Queue<PixelLayerList> canvasHistory;
  Queue<PixelLayerList> canvasFuture;
  int layerNamingCounter;
  int canvasWidth;
  int canvasHeight;
  double canvasScale;
  ColorType activeColorType;
  PixelBuffer drawingBuffer;
  HSLColor primaryColor;
  HSLColor secondaryColor;
  PixelLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  BaseTool currentTool;
  PixelLayerList layers;
  DrawerSizeMode leftDrawerSizeMode;
  var palette = <HSLColor>[];
  DrawerSizeMode rightDrawerSizeMode;
  Path selectionPath;
  double toolSize;
  double toolOpacity;
  ShapeMode toolShape;
  bool shapeFilled;


  HSLColor get currentColor =>
      (activeColorType == ColorType.Primary) ? primaryColor : secondaryColor;

}



