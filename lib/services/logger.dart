export 'package:logger/logger.dart' show Level;

import 'dart:developer' as developer;
import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../utils/utils.dart';

class _LogFilter extends LogFilter {
  _LogFilter(Level level) {
    this.level = level;
  }
  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= level!.value;
  }
}

class _ConsoleOutput extends LogOutput {
  final String? prefix;

  _ConsoleOutput({this.prefix});

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      developer.log(line, name: prefix ?? 'Cola');
    }
  }
}

class _SimplePrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.trace: '[T]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.fatal: '[F]',
  };

  static final levelColors = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.none(),
    Level.info: const AnsiColor.fg(12),
    Level.warning: const AnsiColor.fg(208),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };

  final bool printTime;
  final bool colors;

  _SimplePrinter({this.printTime = false, this.colors = true});

  @override
  List<String> log(LogEvent event) {
    final errorStr = _shadeWith(
      event.error != null ? '${event.error} ' : '',
      const AnsiColor.fg(70),
    );
    final timeStr = _shadeWith(
      printTime ? _getTime(event.time) : '',
      const AnsiColor.fg(93),
    );
    return [
      '${_labelFor(event.level)} $timeStr$errorStr${stringify(event.message)}'
    ];
  }

  String _shadeWith(String text, AnsiColor color) =>
      text.isNotEmpty && colors ? color(text) : text;

  String _labelFor(Level level) =>
      _shadeWith(levelPrefixes[level]!, levelColors[level]!);

  String _getTime(DateTime time) {
    String threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = time;
    var h = twoDigits(now.hour);
    var min = twoDigits(now.minute);
    var sec = twoDigits(now.second);
    var ms = threeDigits(now.millisecond);
    return '$h:$min:$sec.$ms ';
  }
}

class LoggerService extends GetxService {
  static LoggerService get to => Get.find();

  final bool usePrettyPrinter;
  final bool skipWidgetBuildTrace;
  final LogFilter _filter;
  late final Logger _logger;

  LoggerService({
    String? prefix,
    File? file,
    bool colors = true,
    bool printTime = true,
    bool printEmojis = true,
    this.usePrettyPrinter = false,
    this.skipWidgetBuildTrace = false,
    Level level = Level.trace,
  }) : _filter = _LogFilter(level) {
    if (file != null) colors = false; // 如果输出到文件，强制禁用颜色显示
    final printer = usePrettyPrinter
        ? PrettyPrinter(
            colors: colors,
            printTime: printTime,
            printEmojis: printEmojis,
            methodCount: 0)
        : _SimplePrinter(colors: colors, printTime: printTime);
    _logger = Logger(
      filter: _filter,
      printer: printer,
      output: file != null
          ? FileOutput(file: file)
          : _ConsoleOutput(prefix: prefix),
    );
  }

  @override
  void onClose() {
    _logger.close();
    super.onClose();
  }

  set level(Level level) => _filter.level = level;
  Level get level => _filter.level!;

  /// Log a message at level [Level.trace].
  void t(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.trace, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.debug].
  void d(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.debug, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info].
  void i(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.info, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.warning, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error].
  void e(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.error, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.fatal].
  void f(
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    log(Level.fatal, message, time: time, tag: tag, stackTrace: stackTrace);
  }

  /// Log a message with [level].
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? tag,
    StackTrace? stackTrace,
  }) {
    if (skipWidgetBuildTrace && level == Level.trace && message == 'build') {
      return;
    }
      
    // 这里利用了error来充当tag, 如果不为空PrettyPrinter会觉得这是一条错误，从而输出堆栈信息
    // 对于PrettyPrinter，如果tag不为空且level>=warning时才使用tag
    if (usePrettyPrinter && tag != null && level.value < Level.warning.value) {
      tag = null;
    }
    _logger.log(level, message, time: time, error: tag, stackTrace: stackTrace);
  }
}
