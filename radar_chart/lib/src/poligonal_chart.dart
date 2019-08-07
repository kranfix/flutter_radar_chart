import 'package:flutter/material.dart';
import 'dart:math' show sin, cos, pi;

class PoligonalChart extends StatelessWidget {
  PoligonalChart({
    @required this.radius,
    @required this.length,
    this.borderStroke,
    this.borderColor,
    this.backgroundColor,
    this.initialAngle: 0,
    this.values,
    this.radialStroke,
    this.radialColor,
  });

  final double radius;
  final int length;
  final double borderStroke;
  final Color borderColor;
  final Color backgroundColor;
  final double initialAngle;
  final List<double> values;
  final double radialStroke;
  final Color radialColor;

  List<Offset> get points {
    final deltaAngle = 2 * pi / length;
    return List.generate(
      length,
      (i) {
        final angle = initialAngle + i * deltaAngle;
        final val =
            values == null || values[i] > 1 ? 1 : values[i] < 0 ? 0 : values[i];
        final dx = radius * (1 + val * sin(angle));
        final dy = radius * (1 + val * cos(angle));
        return Offset(dx, dy);
      },
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tree = SizedBox(width: 2 * radius, height: 2 * radius);

    final _points = points;

    if (radialColor != null && radialStroke != null && radialStroke > 0) {
      tree = CustomPaint(
        painter: _RadialPainter(
          points: _points,
          radialStroke: radialStroke,
          radialColor: radialColor,
        ),
        child: tree,
      );
    }

    if (backgroundColor != null) {
      tree = CustomPaint(
        painter: _PoligonalBackgroundPainter(
          color: backgroundColor,
          points: _points,
        ),
        child: tree,
      );
    }

    if (borderColor != null && borderStroke != null && borderStroke > 0) {
      tree = CustomPaint(
        painter: _PoligonalPainter(
          points: _points,
          borderStroke: borderStroke,
          borderColor: borderColor,
          radialStroke: radialStroke,
          radialColor: radialColor,
        ),
        child: tree,
      );
    }
    return tree;
  }
}

class _PoligonalBackgroundPainter extends CustomPainter {
  _PoligonalBackgroundPainter({this.points, this.color});
  final List<Offset> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _PoligonalPainter extends CustomPainter {
  _PoligonalPainter({
    this.points,
    this.borderStroke,
    this.borderColor,
    this.radialStroke,
    this.radialColor,
  });
  final List<Offset> points;
  final double borderStroke;
  final Color borderColor;
  final double radialStroke;
  final Color radialColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);

    if (borderColor != null && borderStroke != null && borderStroke > 0) {
      final paint = Paint()
        ..color = borderColor
        ..strokeWidth = borderStroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _RadialPainter extends CustomPainter {
  _RadialPainter({
    this.points,
    this.radialStroke,
    this.radialColor,
    this.center,
  });
  final List<Offset> points;
  final double radialStroke;
  final Color radialColor;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = radialColor
      ..strokeWidth = radialStroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final radius = size.width / 2;
    final _center = center ?? Offset(radius, radius);
    for (var point in points) {
      canvas.drawLine(_center, point, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
