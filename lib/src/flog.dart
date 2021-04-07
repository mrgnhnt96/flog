// TODO: clean up!
// TODO: make flog delegate not null and stuff

// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer' as d;

import 'package:ansicolor/ansicolor.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'delegate.dart';
import 'formats/formats.dart';

/// allows customization to the prefix of log
///
/// provides date time and log's tag name
typedef FlogLabeler = String Function(
    DateTime date, String tag, String? feature);
FlogLabeler? _labeler;

FlogDelegate _delegate = FlogDelegate();

/// list of features to reference against
/// to filter info and state logs
List<Object>? _features;

/// all colors and formats for text and background
FlogFormats? _formats;

/// referenced to allow all nav logs
bool _allowNav = true;

/// referenced to allow all state logs
bool _allowState = true;

/// referenced for clean stack trace
bool _useCleanStackTrace = true;

typedef AllowLog = bool Function();

///method to check if logs can be printed
AllowLog _allowLog = () {
  if (kDebugMode) return true;
  if (kProfileMode) return true;
  if (kReleaseMode) return false;
  return false;
};

/// different log types available
enum _FlogTag {
  state,
  nav,
  info,
  important,
  error,
  fatal,
}

extension _FlogExtentions on _FlogTag {
  String get name {
    switch (this) {
      case _FlogTag.state:
        return 'STATE';
      case _FlogTag.nav:
        return 'NAV';
      case _FlogTag.info:
        return 'INFO';
      case _FlogTag.important:
        return 'IMPORTANT';
      case _FlogTag.error:
        return 'ERROR';
      case _FlogTag.fatal:
        return 'FATAL';
      default:
        return '';
    }
  }
}

abstract class Flog {
  const Flog._();

  /// ### Features
  /// #### `.features`
  /// Specify features that can be printed to console
  ///
  /// if `null`, ***all*** features will be printed to console
  ///
  /// Filtering applies to [flogInfo] and [flogState]
  ///
  /// [flogError], [flogImportant], [flogNav], and [flogFatal] will
  /// ***always*** print to console
  ///
  /// ---
  ///
  /// ### Formats
  /// #### `.formats`
  ///
  /// The ability to customize the look of the printed statement.
  ///
  /// Customizable:
  /// - Text:
  ///   * Color
  ///   * Boldness
  ///
  ///
  /// - Background:
  ///   * Color
  ///
  /// ---
  ///
  /// ### Allow Navigation
  /// #### `.allowNav`
  ///
  /// Enable navigation logging
  ///
  /// default: `true`
  ///
  /// ---
  ///
  /// ### Allow State
  /// #### `.allowState`
  ///
  /// Enable state logging
  ///
  /// If `false`, it will override [features] and disable state logging
  ///
  /// if `true`, [features] will be applied and filtered when logging
  ///
  /// ---
  ///
  /// ### Label
  /// #### `.label`
  ///
  /// Customizes prefix of printed logs
  ///
  /// ***limit the amount of logic, may slow performance!***
  ///
  /// #### Values returned
  /// `String Function(DateTime date, String tag, String? feature)`
  /// - date = Time stamp of log
  /// - tag = The type of log
  /// - feature = The feature filter
  ///   - if `null`, or N/A, returns `null`
  ///
  /// ---
  ///
  /// ### Allow Log
  /// #### `.allowLog`
  ///
  /// Method that is checked, before every log to, to see if logging is enabled
  ///
  /// By default, this will log in Debug and Profile modes, and not in Release mod
  ///
  /// default:
  /// ```dart
  /// _allowLog = () {
  ///   if (kDebugMode) return true;
  ///   if (kProfileMode) return true;
  ///   if (kReleaseMode) return false;
  ///   return false;
  /// };
  /// ```
  ///
  /// ---
  ///
  /// ### Clean Stack Trace
  /// #### `.useCleanStackTrace`
  ///
  /// Cleans provided Stack Trace for [flogFatal] and [flogError]
  ///
  /// reference https://pub.dev/packages/stack_trace for more info

  static void setUp({
    List<Object>? features,
    FlogFormats? formats,
    bool allowNav: true,
    bool allowState: true,
    FlogLabeler? label,
    AllowLog? allowLog,
    bool ansiColorDisabled: false,
    bool useCleanStackTrace: true,
  }) {
    c.ansiColorDisabled = ansiColorDisabled;
    _features = features;
    _formats = formats;
    _labeler = label;
    _allowState = allowState;
    _allowNav = allowNav;
    _useCleanStackTrace = useCleanStackTrace;
    if (allowLog != null) _allowLog = allowLog;
  }

  /// Configure delegate to set logs to analytic services
  static set delegate(FlogDelegate delegate) => _delegate = delegate;

  /// use to quickly test all flog formats and colors
  static void runFormatTest() {
    flogError('this is the ERROR flog w/o stack track');
    flogError('this is the ERROR flog w/ stack track', StackTrace.current);
    flogFatal('this is the FATAL flog w/o stack track');
    flogFatal('this is the FATAL flog w/ stack track', StackTrace.current);
    flogImportant('this is the IMPORTANT flog');
    flogInfo('this is the INFO flog');
    flogState('this is the STATE flog');
    flogNav('this is the NAV flog');
  }
}

/// Use [flogState] to produce logs regarding state changes.
///
/// by adding a feature, this log will be filtered based off of
/// the features that you are allowing to print via
/// `Flog.setUp(features: [...])`
///
/// leave [feature] null to always print to console
void flogState(Object? object, [Object? feature]) {
  if (_delegate.flogState != null) _delegate.flogState!(object, feature);
  _filterAndLog(_FlogTag.state, object, feature: feature);
}

/// Use `flogNav` to produce logs regarding navigation changes.
void flogNav(Object? object) {
  if (_delegate.flogNav != null) _delegate.flogNav!(object);
  _filterAndLog(_FlogTag.nav, object);
}

/// Use [flogInfo] to produce informative logs.
///
/// by adding a feature, this log will be filtered based off of
/// the features that you are allowing to print via
/// `Flog.setUp(features: [...])`
///
/// leave [feature] null to always print to console
void flogInfo(Object? object, [Object? feature]) {
  if (_delegate.flogInfo != null) _delegate.flogInfo!(object, feature);
  _filterAndLog(_FlogTag.info, object, feature: feature);
}

/// Use [flogImportant] to produce logs that may may require
/// additional attention
///
/// use cases:
/// - unexpected events
/// - significant info
/// - unwanted events
void flogImportant(Object? object) {
  if (_delegate.flogImportant != null) _delegate.flogImportant!(object);
  _filterAndLog(_FlogTag.important, object);
}

/// Use [flogError] in an event of an exception or an undesired result
void flogError(Object? object, [dynamic stackTrace]) {
  if (_delegate.flogError != null) _delegate.flogError!(object, stackTrace);
  _filterAndLog(_FlogTag.error, object, stackTrace: stackTrace);
}

/// Use [flogFatal] to produce a log that represents an irreparable
/// situation
void flogFatal(Object? object, [dynamic stackTrace]) {
  if (_delegate.flogFatal != null) _delegate.flogFatal!(object);
  _filterAndLog(_FlogTag.fatal, object, stackTrace: stackTrace);
}

void _filterAndLog(
  _FlogTag tag,
  Object? object, {
  dynamic stackTrace,
  Object? feature,
}) {
  final message = object.toString();
  if (!_allowLog()) return;

  void _printMessage(StatementFormat? format) {
    late String _prefix;
    if (_labeler != null)
      _prefix = _labeler!(DateTime.now(), tag.name, feature.toString());
    else
      _prefix = tag.name;

    String? _stackTrace;
    if (stackTrace != null)
      _stackTrace = _useCleanStackTrace
          ? '\n${Trace.from(stackTrace).terse}'
          : '\n$stackTrace';

    if (format == null) {
      final _formattedPrefix =
          _prefix[_prefix.length - 1] == ' ' ? _prefix : _prefix + ' ';
      print(_formattedPrefix + message + (_stackTrace ?? ''));
      return;
    }
    final _formattedMessage = format.apply(message) + (_stackTrace ?? '');
    d.log(
      _formattedMessage,
      name: _prefix,
      time: DateTime.now(),
    );
  }

  switch (tag) {
    case _FlogTag.nav:
      if (_allowNav) _printMessage(_formats?.nav);
      break;
    case _FlogTag.state:
      if (_allowState) {
        if (_features == null ||
            feature == null ||
            _features!.contains(feature)) _printMessage(_formats?.state);
      }
      break;

    case _FlogTag.info:
      if (_features == null || feature == null || _features!.contains(feature))
        _printMessage(_formats?.info);
      break;

    case _FlogTag.important:
      _printMessage(_formats?.important);
      break;

    case _FlogTag.error:
      _printMessage(_formats?.error);
      break;

    case _FlogTag.fatal:
      _printMessage(_formats?.fatal);
      break;

    default:
      _printMessage(null);
      break;
  }
}
