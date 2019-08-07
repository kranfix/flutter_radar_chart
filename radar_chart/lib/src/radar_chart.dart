import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_tile.dart';

enum RadarChatType { cirular, poligonal }

class RadarChart extends InheritedWidget {
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
  }) : super(
          child: Stack(
            children: [
              RadarTile(
                backgroundColor: backgroundColor,
                borderStroke: borderStroke,
                borderColor: borderColor,
                radialStroke: radialStroke,
                radialColor: radialColor,
              ),
            ]..addAll(radars),
          ),
        );

  final double radius;
  final int length;
  final double borderStroke;
  final Color borderColor;
  final Color backgroundColor;
  final double radialStroke;
  final Color radialColor;
  final List<RadarTile> radars;
  final double initialAngle;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static RadarChart of(BuildContext context) =>
      context.ancestorInheritedElementForWidgetOfExactType(RadarChart).widget;
}
