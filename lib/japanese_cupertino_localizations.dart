import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class _CupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ja';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      JapaneseCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_CupertinoLocalizationDelegate old) => false;

  @override
  String toString() => 'DefaultCupertinoLocalizations.delegate(ja_JP)';
}

class JapaneseCupertinoLocalizations implements CupertinoLocalizations {
  const JapaneseCupertinoLocalizations();

  static const List<String> _shortWeekdays = <String>[
    '(月)',
    '(火)',
    '(水)',
    '(木)',
    '(金)',
    '(土)',
    '(日)',
  ];

  static const List<String> _shortMonths = <String>[
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月',
  ];

  static const List<String> _months = <String>[
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月',
  ];

  @override
  String datePickerYear(int yearIndex) => '$yearIndex年';

  @override
  String datePickerMonth(int monthIndex) => _months[monthIndex - 1];

  @override
  String datePickerDayOfMonth(int dayIndex) => '$dayIndex日';

  @override
  String datePickerHour(int hour) => hour.toString();

  @override
  String datePickerHourSemanticsLabel(int hour) => hour.toString() + "時";

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    if (minute == 1) return '1 分';
    return minute.toString() + '分';
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_shortMonths[date.month - DateTime.january]} '
        '${date.day.toString() + '日'}'
        '${_shortWeekdays[date.weekday - DateTime.monday]} ';
  }

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String get anteMeridiemAbbreviation => '午前';

  @override
  String get postMeridiemAbbreviation => '午後';

  @override
  String get alertDialogLabel => 'Info';

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerHourLabel(int hour) => hour == 1 ? '時' : '時';

  @override
  String timerPickerMinuteLabel(int minute) => '分';

  @override
  String timerPickerSecondLabel(int second) => '秒';

  @override
  String get cutButtonLabel => 'カット';

  @override
  String get copyButtonLabel => 'コピー';

  @override
  String get pasteButtonLabel => 'ペースト';

  @override
  String get selectAllButtonLabel => '選択';

  @override
  String get todayLabel => '今日';

  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
        const JapaneseCupertinoLocalizations());
  }

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CupertinoLocalizationDelegate();

  @override
  // TODO: implement modalBarrierDismissLabel
  String get modalBarrierDismissLabel => throw UnimplementedError();

  @override
  String tabSemanticsLabel({int tabIndex, int tabCount}) {
    // TODO: implement tabSemanticsLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement searchTextFieldPlaceholderLabel
  String get searchTextFieldPlaceholderLabel => throw UnimplementedError();

  @override
  // TODO: implement timerPickerHourLabels
  List<String> get timerPickerHourLabels => throw UnimplementedError();

  @override
  // TODO: implement timerPickerMinuteLabels
  List<String> get timerPickerMinuteLabels => throw UnimplementedError();

  @override
  // TODO: implement timerPickerSecondLabels
  List<String> get timerPickerSecondLabels => throw UnimplementedError();
}
