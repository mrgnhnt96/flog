<p align="center">
<img src="https://github.com/mrgnhnt96/flog/blob/master/assets/images/flog.png" height="100" alt="flog" />
</p>

---

A feature based logging library that helps filter logs and keep the console clean.

---

## Overview

The goal of this package is to maintain a clean console by filtering logs based on features.

This allows to keep all logs, and to optionally allow *featured specific* logs to print to console.

Flog enables customization to printed logs, by changing its color, boldness, and background. Making it easy to spot different logs types.

Flog has an open API to easily integrate any analytic tools or services, by using its `delegate` feature.

---

## Getting Started

### Set Up

Although Flog works right without any initial set up, the API is open to set up logs.

```dart
Flog.setUp(
    label: String Function(DateTime date, String tag, String? feature)
    allowLog: bool Function(),
    ansiColorDisabled: bool,
    useCleanStackTrace: bool,
    formats: FlogFormats(
      error: StatementFormat(
        backgroundColor: BackgroundColor(FlogColors, {RGB rgb}),
        textFormat: TextFormat(FlogColors, {bool isBold = false, RGB rgb})
      ),
      fatal: StatementFormat,
      important: StatementFormat,
      info: StatementFormat,
      nav: StatementFormat,
      state: StatementFormat,
    ),
  );
```
---

### Label
A string will be inserted as a prefix to each log. Provides the time stamp, the tag (type of log), and the feature (if provided, returns `null` if none).

By default, the label uses only [tag].

---

### Allow Log
A check before every log. This is helpful to only print in development or profile modes. Printing should be avoided in release mode.

***note:*** Allow log only affects printing to console, the delegate will still be called for every log.

default:
```dart
.allowLog = () {
  if (kDebugMode) return true;
  if (kProfileMode) return true;
  if (kReleaseMode) return false;
  return false;
};
```

---

### Ansi Color Disabled
Flog depends on AnsiColor to customize print statements. If customization is not working, try changing this value.

Reference https://pub.dev/packages/ansicolor for more info.

default:
```dart
.ansiColorDisabled = false,
```

---

### Use Clean Stack Trace
Flog depends on stack_trace to clean stack traces provided for `flogFatal` and `flogError`. To use Darts original Stack Trace, set to `false`.

default:
```dart
.useCleanStackTrace = true,
```

---

### Formats
Customize how each log looks in console to easily distinguish between each different log type.

Set formats, or a specific log type, to `null` to use the default console's settings.

default:
```dart
.formats = null,
```

Available Colors:

```dart
FlogColors {
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
```

To use a custom color, use `FlogColors.custom` and provide an [RGB]
```dart
StatementFormat(
    textFormat: TextFormat(
        FlogColors.custom,
        rgb: const RGB(red: 89, blue: 231, green: 245),
        isBold: true,
    ),
),
```

***note:*** To quickly test your formats, you can call:
```dart
Flog.runFormatTest();
```

---
---

## Filtering

Flog has the ability to filter specific logs to the console.

```dart
Flog.filter(
    List<Object>?,
    allowNav: bool,
    allowState: bool,
  );
```

To show all logs:
```dart
// by default, or by setting null, all logs will be shown
Flog.filter(null);
```

Features can be any type. enum, num, String, ect.

Example:

```dart
enum Filter {
    one,
    two,
}

void main() {
    Flog.filter([Filter.one]);

    flogInfo('this will always be printed');
    flogInfo('this will NOT be printed', Filter.two);
    flogInfo('this WILL be printed', Filter.one);
}
```

---

### Allow State

You have the ability to override all state logs. 
`false` will disable all state logs,
`true` will enable all state logs, still filterable by features.

```dart
//default = true
Flog.filter(..., allowState: bool);
```

---

### Allow Nav

You have the ability to override all nav logs. 
`false` will disable all nav logs,
`true` will enable all nav logs.

```dart
//default = true
Flog.filter(..., allowNav: bool);
```

---
---

## Log Types

There are 6 different logs available

> state, nav, info, important, error, fatal

---

### State

```dart
flogState(Object? message, [Object? feature]);
```

This is intended for all state changes with your choice of State Management Provider.

You can pass an optional parameter, [feature], to add a Feature specific filter. If no feature is provided, it will always print to console. By providing a feature, the log with ***always*** show, unless `Flog.filter(...)` contains a value.

---

### Nav

```dart
flogNav(Object? message);
```

This is intended for all navigation changes.

---

### Info

```dart
flogInfo(Object? message, [Object? feature]);
```

This is similiar to the basic print statement. All dev, testing, and non-important logs.

You can pass an optional parameter, [feature], to add a Feature specific filter.

---

### Important

```dart
flogImportant(Object? message);
```

This is intended for all important logs, logs that may require additional attention.

Use cases:
- Unexpected events
- Significant info
- Unwanted events

---

### Error

```dart
flogError(Object? object, [dynamic stackTrace]);
```

This is intended for logs of an exception or an undesired result.

---

### Fatal

```dart
flogFatal(Object? object, [dynamic stackTrace]);
```

This is intended for logs that represent an irreparable situation.

---
---

## Observing logs

Each corresponding log type has a delegate that can be used to incorporate analytics or services.

```dart
Flog.delegate = FlogDelegate(
    flogState: void Function(Object? object, [Object? feature]),
    flogNav: void Function(Object? object),
    flogInfo: void Function(Object? object, [Object? feature]),
    flogImportant: void Function(Object? object),
    flogError: void Function(Object? object, [dynamic stackTrace]),
    flogFatal: void Function(Object? object, [dynamic stackTrace]),
);
```