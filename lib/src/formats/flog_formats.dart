import 'statement.dart';

class FlogFormats {
  const FlogFormats({
    this.state,
    this.nav,
    this.info,
    this.important,
    this.error,
    this.fatal,
  });

  final StatementFormat? state;
  final StatementFormat? nav;
  final StatementFormat? info;
  final StatementFormat? important;
  final StatementFormat? error;
  final StatementFormat? fatal;
}
