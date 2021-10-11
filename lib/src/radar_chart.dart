import 'package:flutter/material.dart';
import 'package:radar_chart/src/radar_chart_not_found_error.dart';
import 'package:radar_chart/src/radar_tile.dart';

/// The [RadarData] has data for all [RadarTile] configuration
mixin RadarData {
  /// Number of points to draw for the [RadarChart]
  /// in every [RadarTile]
  int get length;

  /// [RadarChart] radius
  double get radius;

  /// Rotates the radar chart at an initial angle in radians in clockwise
  double get initialAngle;
}

/// Defines if the [RadarChart] draw polygons or circumferences
enum RadarChatType {
  /// Draws circunferences
  circular,

  /// Draws polygons
  poligonal,
}

/// {@template radar_chart}
/// Radar chart, also known as Spider chart
/// {@endtemplate}
class RadarChart extends InheritedWidget with RadarData {
  /// {@macro radar_chart}
  RadarChart({
    Key? key,
    required this.radius,
    required this.length,
    this.initialAngle = 0,
    this.backgroundColor,
    this.borderStroke = 4.0,
    this.borderColor,
    this.radialStroke,
    this.radialColor,
    this.radars = const [],
    this.vertices,
  })  : assert(length >= 3),
        assert(radius > 0),
        super(
          key: key,
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
  @override
  final double radius;

  /// Number of edges or nodes
  @override
  final int length;

  /// Rotates the radar chart at an initial angle in radians in clockwise
  @override
  final double initialAngle;

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

  /// Strokewidth of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialColor]
  final double? radialStroke;

  /// Color of lines from the center of the circumscribed circumference
  /// To work, it is necessary to set [radialStroke]
  final Color? radialColor;

  /// Each [RadarTile] specifies a radarchart
  final List<RadarTile> radars;

  /// Optional vertices widgets. They must be a [PreferredSizeWidget] and
  /// their centers will match their respective vertice.
  final List<PreferredSizeWidget>? vertices;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  /// Returns the [RadarChart] from the [BuildContext]
  static RadarData of(BuildContext context) {
    final chart = context.findAncestorWidgetOfExactType<RadarChart>();
    if (chart == null) {
      throw RadarChartNotFoundError(context.widget.runtimeType);
    }
    return chart;
  }
}
