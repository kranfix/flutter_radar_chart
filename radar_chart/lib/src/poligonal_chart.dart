import 'package:flutter/widgets.dart';
import 'dart:math' show sin, cos, pi;

class PoligonalChart extends StatelessWidget {
  PoligonalChart({
    @required this.radius,
    @required this.length,
    this.stroke: 4.0,
    this.borderColor: const Color(0x00FFFFFF),
    this.backgroundColor: const Color(0x00FFFFFF),
    this.initialAngle: 0,
    this.values: const [],
  });

  final double radius;
  final int length;
  final double stroke;
  final Color borderColor;
  final Color backgroundColor;
  final double initialAngle;
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _PoligonalClipper(
        radius: radius,
        initialAngle: initialAngle,
        values: values,
      ),
      child: Container(
        width: 2 * radius,
        height: 2 * radius,
      ),
    );
  }
}

class _PoligonalClipper extends CustomClipper<Path> {
  _PoligonalClipper({
    @required this.radius,
    this.initialAngle = 0,
    @required this.values,
  })  : assert(values != null),
        assert(radius != null),
        assert(initialAngle != null);

  final double radius;
  final double initialAngle;
  final List<double> values;

  @override
  Path getClip(Size size) {
    final deltaAngle = 2 * pi / values.length;
    return Path()
      ..addPolygon(
        List.generate(
          values.length,
          (i) {
            final angle = initialAngle + i * deltaAngle;
            final dx = radius * (1 + sin(angle));
            final dy = radius * (1 + cos(angle));
            return Offset(dx, dy);
          },
          growable: false,
        ),
        true,
      );
  }

  @override
  bool shouldReclip(_PoligonalClipper oldClipper) => true;
}
