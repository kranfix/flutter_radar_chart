class RadarData {
  const RadarData({
    required this.length,
    required this.radius,
    this.initialAngle = 0,
  }) : assert(length >= 3);

  /// Number of points to draw for the [RadarChart]
  /// every [RadarTile]
  final int length;

  /// [RadarChart] radius
  final double radius;

  /// Rotates the radar chart at an initial angle in radians in clockwise
  final double initialAngle;
}
