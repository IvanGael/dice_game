import 'package:flutter/material.dart';

class DiceConfig {
  final String id;
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
    required this.id,
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


  DiceConfig copyWith({
    String? id,
    Offset? position,
    double? size,
    Color? cubeColor,
    Color? outlineColor,
    Color? dotColor,
    int? faceValue,
    bool? isRolling,
    bool? isCustomizing,
    List<String>? customFaces,
  }) {
    return DiceConfig(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      cubeColor: cubeColor ?? this.cubeColor,
      outlineColor: outlineColor ?? this.outlineColor,
      dotColor: dotColor ?? this.dotColor,
      faceValue: faceValue ?? this.faceValue,
      isRolling: isRolling ?? this.isRolling,
      isCustomizing: isCustomizing ?? this.isCustomizing,
      customFaces: customFaces ?? this.customFaces,
    );
  }
}