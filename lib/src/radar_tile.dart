import 'dart:math' show sin, cos, pi;
import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_chart.dart';

/// {@template radar_tile}
/// [RadarTile] paints a polygon with optional edges, background or
/// radial lines (lines from each node to the center)
/// {@endtemplate}
class RadarTile extends StatelessWidget {
  /// {@macro radar_tile}
  const RadarTile({
    Key? key,
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
        assert(vertices == null || vertices.length > 2),
        super(key: key);

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

  List<Offset> _calculatePoints(RadarData radar) {
    final radius = radar.radius;
    final length = radar.length;
    final deltaAngle = 2 * pi / length;
    final initialAngle = radar.initialAngle;
    return List.generate(
      length,
      (i) {
        final angle = initialAngle + i * deltaAngle;
        final val = values?[i].clamp(0.0, 1.0) ?? 1.0;
        final dx = radius * (1 + val * cos(angle));
        final dy = radius * (1 + val * sin(angle));
        return Offset(dx, dy);
      },
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final radar = RadarChart.of(context);
    final points = _calculatePoints(radar);

    Widget tree = CustomPaint(
      painter: _RadarTilePainter(
        points: points,
        backgroundColor: backgroundColor,
        border: _LineData.tryOrNull(borderColor, borderStroke),
        radial: _LineData.tryOrNull(radialColor, radialStroke),
      ),
    );

    if (vertices != null) {
      final _vertices = vertices!;
      tree = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(child: tree),
          for (int i = 0; i < radar.length; i++)
            Positioned(
              left: points[i].dx - _vertices[i].preferredSize.width / 2,
              top: points[i].dy - _vertices[i].preferredSize.height / 2,
              child: _vertices[i],
            ),
        ],
      );
    }

    final width = 2 * radar.radius;
    return SizedBox(width: width, height: width, child: tree);
  }
}

class _RadarTilePainter extends CustomPainter {
  const _RadarTilePainter({
    required this.points,
    this.backgroundColor,
    this.border,
    this.radial,
  });

  final List<Offset> points;
  final Color? backgroundColor;
  final _LineData? border;
  final _LineData? radial;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);
    paintBg(canvas, size, path);
    paintRadial(canvas, size);
    paintEdges(canvas, size);
  }

  void paintBg(Canvas canvas, Size size, Path path) {
    if (backgroundColor == null) return;
    final paint = Paint()
      ..color = backgroundColor!
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  void paintRadial(Canvas canvas, Size size) {
    if (radial == null) return;
    final paint = Paint()
      ..color = radial!.color
      ..strokeWidth = radial!.stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final point in points) {
      canvas.drawLine(size.center(Offset.zero), point, paint);
    }
  }

  void paintEdges(Canvas canvas, Size size) {
    if (border == null) return;
    final path = Path()..addPolygon(points, true);
    final paint = Paint()
      ..color = border!.color
      ..strokeWidth = border!.stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LineData {
  const _LineData(this.color, this.stroke) : assert(stroke > 0.0);

  static _LineData? tryOrNull(Color? color, double? stroke) {
    if (color == null || (stroke ?? 0.0) == 0.0) return null;
    return _LineData(color, stroke!);
  }

  final Color color;
  final double stroke;
}
