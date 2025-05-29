import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  Log._();

  /// 默认 logger 实例
  static final Logger _logger = Logger(
    level: kDebugMode ? Level.debug : Level.off, // release 环境关闭日志
    printer: PrettyPrinter(
      methodCount: 2,
      // 显示调用栈方法数
      errorMethodCount: 5,
      // 错误时显示更多调用栈
      lineLength: 120,
      // 一行最长字符数
      colors: true,
      // 是否使用颜色
      printEmojis: true,
      // 是否显示 emoji 图标
      dateTimeFormat: DateTimeFormat.dateAndTime, // 显示时间
    ),
  );

  /// debug 日志
  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// info 日志
  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// warning 日志
  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// error 日志
  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// trace 日志（verbose）
  static void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.t(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// fatal 日志（严重错误）
  static void wtf(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(
      message,
      time: time ?? DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
