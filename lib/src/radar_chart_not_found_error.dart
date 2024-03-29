import 'package:flutter/widgets.dart';
import 'package:radar_chart/radar_chart.dart';

/// The error that will be thrown if [RadarChart.of] fails to
/// find a [RadarData] as an ancestor of the [BuildContext] used.
class RadarChartNotFoundError extends Error {
  /// Create a ProviderNotFound error with the type represented as a String.
  RadarChartNotFoundError(this.widgetType);

  /// The type of the Widget requesting the value
  final Type widgetType;

  @override
  String toString() {
    return '''
Error: Could not find the correct RadarChart above this $widgetType Widget
To fix, please:
  * RadarData
  * Always use package imports. Ex: `import 'package:my_app/my_code.dart';
  * Ensure the correct `context` is being used.
If none of these solutions work, please file a bug at:
https://github.com/kranfix/flutter_radar_chart/issues
''';
  }
}
