// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

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
