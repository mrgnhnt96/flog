enum FlogColors {
  black,
  blue,
  cyan,
  gray,
  green,
  red,
  white,
  yellow,
  custom,
}

/// create custom color
///
/// max 225
class RGB {
  const RGB({
    /// max 255
    num red: 0,

    /// max 255
    num blue: 0,

    /// max 255
    num green: 0,
  })  : _red = red,
        _blue = blue,
        _green = green;

  /// max 255
  final num _red;

  /// max 255
  final num _blue;

  /// max 255
  final num _green;

  double get red => _red.clamp(0, 255) / 255;
  double get blue => _blue.clamp(0, 255) / 255;
  double get green => _green.clamp(0, 255) / 255;
}
