// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;

import 'constants.dart';
import 'dice_game_board.dart';

class CubeHome extends StatelessWidget {
  const CubeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/cbh2.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          const Center(child: CubeHomeWidget())
        ],
      ),
    );
  }
}

class CubeHomeWidget extends StatefulWidget {
  const CubeHomeWidget({super.key});

  @override
  _CubeHomeWidgetState createState() => _CubeHomeWidgetState();
}

class _CubeHomeWidgetState extends State<CubeHomeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _animationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..addListener(() {
        setState(() {
          _animationProgress = _controller.value;
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const DiceGameBoard()));
      }
    });

    _controller.forward().then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => const DiceGameBoard()));
    });

    _toggleAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CubeHomePainter(_animationProgress),
      size: const Size(300, 300)
    );
  }
}

class CubeHomePainter extends CustomPainter {
  final double animationProgress;
  CubeHomePainter(this.animationProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.blueShade100
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = AppConstants.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dotPaint = Paint()
      ..color = AppConstants.black
      ..style = PaintingStyle.fill;

    // final center = Offset(size.width / 2, size.height / 2);
    final sideLength = size.width / 4;

    List<vector.Vector3> cubeVertices = [
      vector.Vector3(-1, -1, -1),
      vector.Vector3(1, -1, -1),
      vector.Vector3(1, 1, -1),
      vector.Vector3(-1, 1, -1),
      vector.Vector3(-1, -1, 1),
      vector.Vector3(1, -1, 1),
      vector.Vector3(1, 1, 1),
      vector.Vector3(-1, 1, 1),
    ];

    List<List<int>> cubeFaces = [
      [0, 1, 2, 3], // Front
      [5, 4, 7, 6], // Back
      [4, 0, 3, 7], // Left
      [1, 5, 6, 2], // Right
      [4, 5, 1, 0], // Bottom
      [3, 2, 6, 7], // Top
    ];

    List<int> faceValues = [1, 6, 3, 4, 5, 2];

    // Create projection matrix
    var aspect = size.width / size.height;
    var projectionMatrix =
        vector.makePerspectiveMatrix(45 * math.pi / 180, aspect, 0.1, 100);

    // Create view matrix
    var viewMatrix = vector.makeViewMatrix(
      vector.Vector3(0, 0, 5),
      vector.Vector3(0, 0, 0),
      vector.Vector3(0, 1, 0),
    );

    // Create model matrix
    var modelMatrix = vector.Matrix4.identity();

    if (animationProgress < 0.5) {
      // Rotating cube
      modelMatrix.rotateY(animationProgress * math.pi);
      modelMatrix.rotateX(animationProgress * math.pi / 2);
    } else {
      // Unfolding to 3x3 grid
      var unfoldProgress = (animationProgress - 0.5) * 2;
      modelMatrix.translate(vector.Vector3(0, 0, -3 + 3 * unfoldProgress));

      for (int i = 0; i < cubeFaces.length; i++) {
        var faceCenter = vector.Vector3.zero();
        for (var vertexIndex in cubeFaces[i]) {
          faceCenter += cubeVertices[vertexIndex];
        }
        faceCenter /= 4;

        var faceMatrix = vector.Matrix4.identity();
        faceMatrix.translate(faceCenter * unfoldProgress * 2);

        if (i > 0) {
          var rotationAxis = faceCenter.normalized();
          faceMatrix.rotate(rotationAxis, unfoldProgress * math.pi / 2);
        }

        _drawFace(
            canvas,
            size,
            cubeFaces[i],
            cubeVertices,
            faceValues[i],
            sideLength,
            paint,
            outlinePaint,
            dotPaint,
            projectionMatrix,
            viewMatrix,
            modelMatrix * faceMatrix);
      }
      return;
    }

    // Draw cube faces
    for (int i = 0; i < cubeFaces.length; i++) {
      _drawFace(
          canvas,
          size,
          cubeFaces[i],
          cubeVertices,
          faceValues[i],
          sideLength,
          paint,
          outlinePaint,
          dotPaint,
          projectionMatrix,
          viewMatrix,
          modelMatrix);
    }
  }

  void _drawFace(
      Canvas canvas,
      Size size,
      List<int> face,
      List<vector.Vector3> vertices,
      int faceValue,
      double sideLength,
      Paint paint,
      Paint outlinePaint,
      Paint dotPaint,
      vector.Matrix4 projectionMatrix,
      vector.Matrix4 viewMatrix,
      vector.Matrix4 modelMatrix) {
    var transformedVertices = face.map((index) {
      var vertex = vertices[index];
      var transformed = projectionMatrix *
          viewMatrix *
          modelMatrix *
          vector.Vector4(vertex.x, vertex.y, vertex.z, 1);
      transformed /= transformed.w;
      return Offset(
        (transformed.x + 1) * size.width / 2,
        (-transformed.y + 1) * size.height / 2,
      );
    }).toList();

    var path = Path()..addPolygon(transformedVertices, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);

    // Calculate face center for drawing dots
    var faceCenter = transformedVertices.reduce((a, b) => a + b) / 4;
    _drawDots(canvas, faceValue, sideLength / 2, dotPaint, center: faceCenter);
  }

  void _drawDots(
      Canvas canvas, int faceValue, double sideLength, Paint dotPaint,
      {required Offset center}) {
    final dotRadius = sideLength / 10;
    final dotOffset = sideLength / 4;

    switch (faceValue) {
      case 1:
        canvas.drawCircle(center, dotRadius, dotPaint);
        break;
      case 2:
        canvas.drawCircle(
            center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
        break;
      case 3:
        canvas.drawCircle(
            center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(center, dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
        break;
      case 4:
        canvas.drawCircle(
            center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
        break;
      case 5:
        canvas.drawCircle(
            center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(center, dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
        break;
      case 6:
        canvas.drawCircle(
            center + Offset(-dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, -dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(center + Offset(-dotOffset, 0), dotRadius, dotPaint);
        canvas.drawCircle(center + Offset(dotOffset, 0), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(-dotOffset, dotOffset), dotRadius, dotPaint);
        canvas.drawCircle(
            center + Offset(dotOffset, dotOffset), dotRadius, dotPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
