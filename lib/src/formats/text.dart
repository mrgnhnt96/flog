import 'colors.dart';

class TextFormat {
  const TextFormat._(
    this.color, {
    required this.isBold,
    this.rgb,
  });

  factory TextFormat(
    FlogColors color, {
    bool isBold: false,
    RGB? rgb,
  }) {
    if (color == FlogColors.custom && rgb == null)
      print('YOU MUST PROVIDE AN RGB TO USE A CUSTOM COLOR');
    return TextFormat._(
      color,
      rgb: rgb,
      isBold: isBold,
    );
  }

  final FlogColors color;
  final RGB? rgb;
  final bool isBold;
}
