// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import 'package:vector_math/vector_math_64.dart' as vector;

// class CubeToDieWidget extends StatefulWidget {
//   final double size;
//   final Color cubeColor;
//   final Color outlineColor;
//   final Color dotColor;
//   final int faceValue;
//   final bool isRolling;

//   const CubeToDieWidget({
//     super.key,
//     required this.size,
//     required this.cubeColor,
//     required this.outlineColor,
//     required this.dotColor,
//     required this.faceValue,
//     required this.isRolling,
//   });

//   @override
//   _CubeToDieWidgetState createState() => _CubeToDieWidgetState();
// }

// class _CubeToDieWidgetState extends State<CubeToDieWidget> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late AnimationController _controller2;
//   double _animationProgress = 0.0;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     )..addListener(() {
//         setState(() {
//           _animationProgress = _controller.value;
//         });
//       });
    

//     _controller2 = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

//     if (widget.isRolling) {
//       _controller.repeat();
//     } else {
//       _controller.stop();
//     }
//   }

//   @override
//   void didUpdateWidget(CubeToDieWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isRolling && !_controller.isAnimating) {
//       _controller.repeat();
//     } else if (!widget.isRolling && _controller.isAnimating) {
//       _controller.stop();
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _controller2.dispose();
//     super.dispose();
//   }

//   void _toggleAnimation() {
//     if (_controller.status == AnimationStatus.completed) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.isRolling ? _buildRollingDice() 
//     : GestureDetector(
//       onTap: _toggleAnimation,
//       child: CustomPaint(
//         painter: CubeToDiePainter(
//           _animationProgress,
//           widget.cubeColor,
//           widget.outlineColor,
//           widget.dotColor,
//         ),
//         size: Size(widget.size, widget.size),
//       ),
//     );
//   }

//   // Builds the dice during the rolling animation
//   Widget _buildRollingDice() {
//     return RotationTransition(
//       turns: _animation,
//       child: Container(
//         decoration: BoxDecoration(
//           color: widget.cubeColor,
//           border: Border.all(color: widget.outlineColor, width: 2),
//         ),
//         child: Center(
//           child: Icon(
//             Icons.casino,
//             size: widget.size * 0.6,
//             color: widget.dotColor,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CubeToDiePainter extends CustomPainter {
//   final double animationProgress;
//   final Color cubeColor;
//   final Color outlineColor;
//   final Color dotColor;
//   CubeToDiePainter(
//     this.animationProgress,
//     this.cubeColor,
//     this.outlineColor,
//     this.dotColor
//   );

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = cubeColor
//       ..style = PaintingStyle.fill;

//     final outlinePaint = Paint()
//       ..color = outlineColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     final dotPaint = Paint()
//       ..color = dotColor
//       ..style = PaintingStyle.fill;

//     // final center = Offset(size.width / 2, size.height / 2);
//     final sideLength = size.width / 4;

//     List<vector.Vector3> cubeVertices = [
//       vector.Vector3(-1, -1, -1),
//       vector.Vector3(1, -1, -1),
//       vector.Vector3(1, 1, -1),
//       vector.Vector3(-1, 1, -1),
//       vector.Vector3(-1, -1, 1),
//       vector.Vector3(1, -1, 1),
//       vector.Vector3(1, 1, 1),
//       vector.Vector3(-1, 1, 1),
//     ];

//     List<List<int>> cubeFaces = [
//       [0, 1, 2, 3], // Front
//       [5, 4, 7, 6], // Back
//       [4, 0, 3, 7], // Left
//       [1, 5, 6, 2], // Right
//       [4, 5, 1, 0], // Bottom
//       [3, 2, 6, 7], // Top
//     ];

//     List<int> faceValues = [1, 6, 3, 4, 5, 2];

//     // Create projection matrix
//     var aspect = size.width / size.height;
//     var projectionMatrix = vector.makePerspectiveMatrix(45 * math.pi / 180, aspect, 0.1, 100);

//     // Create view matrix
//     var viewMatrix = vector.makeViewMatrix(
//       vector.Vector3(0, 0, 5),
//       vector.Vector3(0, 0, 0),
//       vector.Vector3(0, 1, 0),
//     );

//     // Create model matrix
//     var modelMatrix = vector.Matrix4.identity();

//     if (animationProgress < 0.5) {
//       // Rotating cube
//       modelMatrix.rotateY(animationProgress * math.pi);
//       modelMatrix.rotateX(animationProgress * math.pi / 2);
//     } else {
//       // Unfolding to 3x3 grid
//       var unfoldProgress = (animationProgress - 0.5) * 2;
//       modelMatrix.translate(vector.Vector3(0, 0, -3 + 3 * unfoldProgress));

//       for (int i = 0; i < cubeFaces.length; i++) {
//         var faceCenter = vector.Vector3.zero();
//         for (var vertexIndex in cubeFaces[i]) {
//           faceCenter += cubeVertices[vertexIndex];
//         }
//         faceCenter /= 4;

//         var faceMatrix = vector.Matrix4.identity();
//         faceMatrix.translate(faceCenter * unfoldProgress * 2);

//         if (i > 0) {
//           var rotationAxis = faceCenter.normalized();
//           faceMatrix.rotate(rotationAxis, unfoldProgress * math.pi / 2);
//         }

//         _drawFace(canvas, size, cubeFaces[i], cubeVertices, faceValues[i], sideLength, paint, outlinePaint, dotPaint, projectionMatrix, viewMatrix, modelMatrix * faceMatrix);
//       }
//       return;
//     }

//     // Draw cube faces
//     for (int i = 0; i < cubeFaces.length; i++) {
//       _drawFace(canvas, size, cubeFaces[i], cubeVertices, faceValues[i], sideLength, paint, outlinePaint, dotPaint, projectionMatrix, viewMatrix, modelMatrix);
//     }
//   }

//   void _drawFace(Canvas canvas, Size size, List<int> face, List<vector.Vector3> vertices, int faceValue, double sideLength, Paint paint, Paint outlinePaint, Paint dotPaint, vector.Matrix4 projectionMatrix, vector.Matrix4 viewMatrix, vector.Matrix4 modelMatrix) {
//     var transformedVertices = face.map((index) {
//       var vertex = vertices[index];
//       var transformed = projectionMatrix * viewMatrix * modelMatrix * vector.Vector4(vertex.x, vertex.y, vertex.z, 1);
//       transformed /= transformed.w;
//       return Offset(
//         (transformed.x + 1) * size.width / 2,
//         (-transformed.y + 1) * size.height / 2,
//       );
//     }).toList();

//     var path = Path()..addPolygon(transformedVertices, true);
//     canvas.drawPath(path, paint);
//     canvas.drawPath(path, outlinePaint);

//     // Calculate face center for drawing dots
//     var faceCenter = transformedVertices.reduce((a, b) => a + b) / 4;
//     _drawDots(canvas, faceValue, sideLength / 2, dotPaint, center: faceCenter);
//   }

//   void _drawDots(Canvas canvas, int faceValue, double sideLength, Paint dotPaint, {required Offset center}) {
//     final dotRadius = sideLength / 10;
//     final dotOffset = sideLength / 4;

//     switch (faceValue) {
//       case 1:
//         canvas.drawCircle(center, dotRadius, dotPaint);
//         break;
//       case 2:
//         canvas.drawCircle(center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
//         break;
//       case 3:
//         canvas.drawCircle(center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center, dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
//         break;
//       case 4:
//         canvas.drawCircle(center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
//         break;
//       case 5:
//         canvas.drawCircle(center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center, dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
//         break;
//       case 6:
//         canvas.drawCircle(center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(-dotOffset, 0), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, 0), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
//         canvas.drawCircle(center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
//         break;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

class CubeToDieWidget extends StatefulWidget {
  final double size;
  final Color cubeColor;
  final Color outlineColor;
  final Color dotColor;
  final int faceValue;
  final bool isRolling;
  final bool isCustomizing;
  final String? customFace;

  const CubeToDieWidget({
    super.key,
    required this.size,
    required this.cubeColor,
    required this.outlineColor,
    required this.dotColor,
    required this.faceValue,
    required this.isRolling,
    required this.isCustomizing,
    this.customFace,
  });

  @override
  _CubeToDieWidgetState createState() => _CubeToDieWidgetState();
}

class _CubeToDieWidgetState extends State<CubeToDieWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    if (widget.isRolling) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(CubeToDieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRolling && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.isRolling ? _buildRollingDice() : _buildStaticDice(),
    );
  }

  // Builds the dice during the rolling animation
  Widget _buildRollingDice() {
    return RotationTransition(
      turns: _animation,
      child: Container(
        decoration: BoxDecoration(
          color: widget.cubeColor,
          border: Border.all(color: widget.outlineColor, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.casino,
            size: widget.size * 0.6,
            color: widget.dotColor,
          ),
        ),
      ),
    );
  }

  // Builds the static dice showing the face value
   Widget _buildStaticDice() {
    return Container(
      decoration: BoxDecoration(
        color: widget.cubeColor,
        border: Border.all(color: widget.outlineColor, width: 2),
      ),
      child: widget.customFace != null && widget.isCustomizing == true
          ? Center(
              child: Text(
                widget.customFace!,
                style: TextStyle(
                  color: widget.dotColor,
                  fontSize: widget.size * 0.5,
                  decoration: TextDecoration.none
                ),
              ),
            )
          : CustomPaint(
              painter: DiceFacePainter(widget.faceValue, widget.dotColor),
            ),
    );
  }
}

class DiceFacePainter extends CustomPainter {
  final int faceValue;
  final Color dotColor;

  DiceFacePainter(this.faceValue, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Calculate the dot radius and positions
    final dotRadius = size.width * 0.08;
    final positions = _getDotPositions(faceValue, size);

    // Draw the dots
    for (var position in positions) {
      canvas.drawCircle(position, dotRadius, paint);
    }
  }

  List<Offset> _getDotPositions(int faceValue, Size size) {
    final middle = Offset(size.width / 2, size.height / 2);
    final offset = size.width * 0.25; // distance from center for corner dots

    switch (faceValue) {
      case 1:
        return [middle];
      case 2:
        return [
          Offset(size.width - offset, size.height - offset),
          Offset(offset, offset),
        ];
      case 3:
        return [
          middle,
          Offset(size.width - offset, size.height - offset),
          Offset(offset, offset),
        ];
      case 4:
        return [
          Offset(size.width - offset, size.height - offset),
          Offset(offset, size.height - offset),
          Offset(size.width - offset, offset),
          Offset(offset, offset),
        ];
      case 5:
        return [
          middle,
          Offset(size.width - offset, size.height - offset),
          Offset(offset, size.height - offset),
          Offset(size.width - offset, offset),
          Offset(offset, offset),
        ];
      case 6:
        return [
          Offset(size.width - offset, size.height - offset),
          Offset(offset, size.height - offset),
          Offset(size.width - offset, offset),
          Offset(offset, offset),
          Offset(size.width - offset, middle.dy),
          Offset(offset, middle.dy),
        ];
      default:
        return [];
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
