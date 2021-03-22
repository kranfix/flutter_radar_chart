import 'dart:math' show sin, cos, pi;
import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_chart.dart';

/// [RadarTile] paints a polygon with optional edges, background or
/// radial lines (lines from each node to the center)
class RadarTile extends StatelessWidget {
  const RadarTile({
    double? borderStroke,
    this.borderColor,
    this.backgroundColor,
    this.values,
    double? radialStroke,
    this.radialColor,
    this.vertices,
  })  : borderStroke = borderStroke ?? 0.0,
        radialStroke = radialStroke ?? 0.0,
        assert(values == null || values.length > 2),
        assert(vertices == null || vertices.length > 2);

  /// Borderline strokewidth
  /// if null, the borderlines does not appear
  /// To work, it is necessary to set [borderColor]
  final double borderStroke;

  /// Borderline color
  /// To work, it is necessary to set [borderStroke]
  final Color? borderColor;

  /// Radar chart Background color
  /// White by default
  final Color? backgroundColor;

  /// A list of values between 0.0 (zero) and 1.0 (one)
  final List<double>? values;

  /// Strokewidth of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialColor]
  final double radialStroke;

  /// Color of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialStroke]
  final Color? radialColor;

  /// Optional vertices widgets. They must be a [PreferredSizeWidget] and
  /// their centers will match their respective vertice.
  final List<PreferredSizeWidget>? vertices;

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
        final val = values?[i].clamp(0.0, 1.0) ?? 0.0;
        final dx = radius * (1 + val * cos(angle));
        final dy = radius * (1 + val * sin(angle));
        return Offset(dx, dy);
      },
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? tree;

    final points = calculatePoints(context);
    final radar = RadarChart.of(context);

    // Paints lines from the center of the widget to each node of the polygon
    if (radialColor != null && radialStroke > 0) {
      tree = CustomPaint(
        painter: _RadialPainter(
          points: points,
          stroke: radialStroke,
          color: radialColor,
          center: Offset(radar.radius, radar.radius),
        ),
        child: tree,
      );
    }

    // Paints polygonal edges if required
    if (borderColor != null && borderStroke > 0) {
      tree = CustomPaint(
        painter: _EdgesPainter(
          points: points,
          stroke: borderStroke,
          color: borderColor!,
        ),
        //child: tree,
      );
    }

    // Paints the polygon backgorund edges if required
    if (backgroundColor != null) {
      tree = CustomPaint(
        painter: _BackgroundPainter(
          color: backgroundColor!,
          points: points,
        ),
        child: tree,
      );
    }

    if (vertices != null) {
      final _vertices = vertices!;
      tree = Stack(
        children: <Widget>[
          if (tree != null) tree,
          for (int i = 0; i < radar.length; i++)
            Transform.translate(
              offset: Offset(
                points[i].dx - _vertices[i].preferredSize.width / 2,
                points[i].dy - _vertices[i].preferredSize.height / 2,
              ),
              child: _vertices[i],
            )
        ],
      );
    }

    final width = 2 * radar.radius;
    return SizedBox(width: width, height: width, child: tree);
  }
}

/// Polygonal backgound painter
class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter({
    required this.points,
    required this.color,
  });

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

/// Paints all the Edges of a polygona
class _EdgesPainter extends CustomPainter {
  _EdgesPainter({
    required this.points,
    required this.stroke,
    required this.color,
  }) : assert(stroke > 0.0);

  final List<Offset> points;
  final double stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);

    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Paints lines from a point (usually the center of the widget)
/// to each node of the polygon
class _RadialPainter extends CustomPainter {
  const _RadialPainter({
    required this.points,
    required this.stroke,
    Color? color,
    required this.center,
  }) : color = color ?? Colors.grey;

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
