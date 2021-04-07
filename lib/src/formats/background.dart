import 'colors.dart';

class BackgroundColor {
  const BackgroundColor._(
    this.color, {
    this.rgb,
  });

  factory BackgroundColor(
    FlogColors color, {
    RGB? rgb,
  }) {
    if (color == FlogColors.custom && rgb == null)
      print('YOU MUST PROVIDE AN RGB TO USE A CUSTOM COLOR');

    return BackgroundColor._(
      color,
      rgb: rgb,
    );
  }

  final FlogColors color;
  final RGB? rgb;
}
