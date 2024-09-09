import 'package:flutter/material.dart';

class DiceConfig {
  Offset position;
  double size;
  Color cubeColor;
  Color outlineColor;
  Color dotColor;
  int faceValue;
  bool isRolling;
  bool isCustomizing;
  List<String> customFaces;

  DiceConfig({
    required this.position,
    required this.size,
    required this.cubeColor,
    required this.outlineColor,
    required this.dotColor,
    this.faceValue = 1,
    this.isRolling = false,
    this.isCustomizing = false,
    List<String>? customFaces,
  }) : customFaces = customFaces ?? List.generate(6, (index) => (index + 1).toString());
}