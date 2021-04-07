import 'package:ansicolor/ansicolor.dart';

import 'background.dart';
import 'colors.dart';
import 'text.dart';

class StatementFormat {
  const StatementFormat({
    TextFormat? textFormat,
    BackgroundColor? backgroundColor,
  })  : _textFormat = textFormat,
        _backgroundColor = backgroundColor;

  final TextFormat? _textFormat;
  final BackgroundColor? _backgroundColor;

  String apply(String str) {
    var _pen = AnsiPen();
    _pen(str);
    _setText(_pen);
    _setBackground(_pen);
    final _str = _pen(str);
    return _str;
  }

  void _setText(AnsiPen pen) {
    final _format = _textFormat;
    if (_format == null) return;
    switch (_format.color) {
      case FlogColors.black:
        pen.black(bold: _format.isBold);
        break;
      case FlogColors.blue:
        pen.blue(bold: _format.isBold);
        break;
      case FlogColors.cyan:
        pen.cyan(bold: _format.isBold);
        break;
      case FlogColors.gray:
        pen.gray();
        break;
      case FlogColors.green:
        pen.green(bold: _format.isBold);
        break;
      case FlogColors.red:
        pen.red(bold: _format.isBold);
        break;
      case FlogColors.white:
        pen.white(bold: _format.isBold);
        break;
      case FlogColors.yellow:
        pen.yellow(bold: _format.isBold);
        break;
      case FlogColors.custom:
        if (_format.rgb == null) break;
        pen.rgb(
          r: _format.rgb!.red,
          b: _format.rgb!.blue,
          g: _format.rgb!.green,
        );
        break;
    }
  }

  void _setBackground(AnsiPen pen) {
    final _format = _backgroundColor;
    if (_format == null) return;
    switch (_format.color) {
      case FlogColors.black:
        pen.black(bg: true);
        break;
      case FlogColors.blue:
        pen.blue(bg: true);
        break;
      case FlogColors.cyan:
        pen.cyan(bg: true);
        break;
      case FlogColors.gray:
        pen.gray(bg: true);
        break;
      case FlogColors.green:
        pen.green(bg: true);
        break;
      case FlogColors.red:
        pen.red(bg: true);
        break;
      case FlogColors.white:
        pen.white(bg: true);
        break;
      case FlogColors.yellow:
        pen.yellow(bg: true);
        break;
      case FlogColors.custom:
        if (_format.rgb == null) break;
        pen.rgb(
          r: _format.rgb!.red,
          b: _format.rgb!.blue,
          g: _format.rgb!.green,
          bg: true,
        );
        break;
    }
  }
}
