import 'package:logger/logger.dart';

abstract class Log {
  /// Print debug log.
  ///
  /// [message] : The message which needed to be print.
  static void printDLog(dynamic message) {
    Logger().d('$message');
  }

  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printILog(dynamic message) {
    Logger().i('$message');
  }

  /// Print error log.
  ///
  /// [message] : The message which needed to be print.
  static void printELog(dynamic message) {
    Logger().e('$message');
  }
}
