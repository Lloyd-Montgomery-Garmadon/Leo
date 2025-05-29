import 'package:logger/logger.dart';

class Log {
  Log._();

  factory Log() => Log._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }
}
