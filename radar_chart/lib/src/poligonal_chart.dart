import 'dart:math' show sin, cos, pi;
import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_chart.dart';

class PoligonalChart extends StatelessWidget {
  PoligonalChart({
    this.borderStroke,
    this.borderColor,
    this.backgroundColor,
    this.values,
    this.radialStroke,
    this.radialColor,
  });

  final double borderStroke;
  final Color borderColor;
  final Color backgroundColor;
  final List<double> values;
  final double radialStroke;
  final Color radialColor;

  List<Offset> calculatePoints(BuildContext context) {
    final radar = RadarChart.of(context);
    final radius = radar.radius;
    final length = radar.length;
    final deltaAngle = 2 * pi / length;
    final initialAngle = radar.initialAngle;
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
    Widget tree;

    final points = calculatePoints(context);
    final radius = RadarChart.of(context).radius;

    if (radialColor != null && radialStroke != null && radialStroke > 0) {
      tree = CustomPaint(
        painter: _PoligonalRadialPainter(
          points: points,
          stroke: radialStroke,
          color: radialColor,
          center: Offset(radius, radius),
        ),
        child: tree,
      );
    }

    if (borderColor != null && borderStroke != null && borderStroke > 0) {
      tree = CustomPaint(
        painter: _PoligonalEdgesPainter(
          points: points,
          stroke: borderStroke,
          color: borderColor,
        ),
        //child: tree,
      );
    }

    if (backgroundColor != null) {
      tree = CustomPaint(
        painter: _PoligonalBackgroundPainter(
          color: backgroundColor,
          points: points,
        ),
        child: tree,
      );
    }
    return SizedBox(width: 2 * radius, height: 2 * radius, child: tree);
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

class _PoligonalEdgesPainter extends CustomPainter {
  _PoligonalEdgesPainter({this.points, this.stroke, this.color});
  final List<Offset> points;
  final double stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);

    if (color != null && stroke != null && stroke > 0) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _PoligonalRadialPainter extends CustomPainter {
  _PoligonalRadialPainter({
    this.points,
    this.stroke,
    this.color,
    this.center,
  });
  final List<Offset> points;
  final double stroke;
  final Color color;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var point in points) {
      canvas.drawLine(center, point, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
