import 'package:logger/logger.dart';

class MyLogger {
  static final Logger _logger = Logger();

  static trace(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.t(message ?? 'No trace available!',
        time: time, error: error, stackTrace: stackTrace);
  }

  static debug(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  static info(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  static warn(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, time: time, error: error, stackTrace: stackTrace);
  }

  static error(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, time: time, error: error, stackTrace: stackTrace);
  }

  static fatalLog(
    message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(message, time: time, error: error, stackTrace: stackTrace);
  }
}
