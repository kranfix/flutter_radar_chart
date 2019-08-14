import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_tile.dart';

enum RadarChatType { cirular, poligonal }

/// Radar chart, also known as Spider chart
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
    this.vertices,
  }) : super(
          child: Stack(children: [
            RadarTile(
              backgroundColor: backgroundColor,
              borderStroke: borderStroke,
              borderColor: borderColor,
              radialStroke: radialStroke,
              radialColor: radialColor,
              vertices: vertices,
            ),
            ...radars
          ]),
        );

  /// Radius of the circumscribed circumference of the radar chart.
  /// This defines the sizes:
  /// width = 2 * radius
  /// height = 2 * radius
  final double radius;

  /// Number of edges or nodes
  final int length;

  /// Borderline strokewidth
  /// if null, the borderlines does not appear
  /// To work, it is necessary to set [borderColor]
  final double borderStroke;

  /// Borderline color
  /// To work, it is necessary to set [borderStroke]
  final Color borderColor;

  /// Radar chart Background color
  /// White by default
  final Color backgroundColor;

  /// Strokewidth of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialColor]
  final double radialStroke;

  /// Color of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialStroke]
  final Color radialColor;

  /// Each [RadarTile] specifies a radarchart
  final List<RadarTile> radars;

  /// Rotates the radar chart at an initial angle in radians in clockwise
  final double initialAngle;

  /// Optional vertices widgets. They must be a [PreferredSizeWidget] and
  /// their centers will match their respective vertice.
  final List<PreferredSizeWidget> vertices;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static RadarChart of(BuildContext context) =>
      context.ancestorInheritedElementForWidgetOfExactType(RadarChart).widget;
}
