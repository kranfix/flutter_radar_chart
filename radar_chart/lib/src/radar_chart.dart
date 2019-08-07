import 'package:flutter/material.dart';
import 'package:radar_chart/src/poligonal_chart.dart';

enum RadarChatType { cirular, poligonal }

class RadarChart extends StatelessWidget {
  RadarChart({
    @required this.radius,
    @required this.length,
    this.backgroundColor: Colors.white,
    this.borderStroke: 4.0,
    this.borderColor,
    this.radialStroke,
    this.radialColor,
    this.radars: const [],
    this.initialAngle: 0,
  });

  final double radius;
  final int length;
  final double borderStroke;
  final Color borderColor;
  final Color backgroundColor;
  final double radialStroke;
  final Color radialColor;
  final List<PoligonalChart> radars;
  final double initialAngle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PoligonalChart(
          length: length,
          radius: radius,
          backgroundColor: backgroundColor,
          borderStroke: borderStroke,
          borderColor: borderColor,
          initialAngle: initialAngle,
          radialStroke: radialStroke,
          radialColor: radialColor,
        ),
      ]..addAll(radars),
    );
  }
}
