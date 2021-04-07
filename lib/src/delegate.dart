typedef FlogStateCallback = void Function(Object? object, [Object? feature]);
typedef FlogNavCallback = void Function(Object? object);
typedef FlogInfoCallback = void Function(Object? object, [Object? feature]);
typedef FlogImportantCallback = void Function(Object? object);
typedef FlogErrorCallback = void Function(Object? object, [dynamic stackTrace]);
typedef FlogFatalCallback = void Function(Object? object, [dynamic stackTrace]);

class FlogDelegate {
  FlogDelegate({
    this.flogState,
    this.flogNav,
    this.flogInfo,
    this.flogImportant,
    this.flogError,
    this.flogFatal,
  });

  final FlogStateCallback? flogState;
  final FlogNavCallback? flogNav;
  final FlogInfoCallback? flogInfo;
  final FlogImportantCallback? flogImportant;
  final FlogErrorCallback? flogError;
  final FlogFatalCallback? flogFatal;
}
