import 'package:flutterappdemo/resources/const_info.dart';
import 'package:logger/logger.dart';

class Log {
  static final logger = Logger(
    printer: PrettyPrinter(
        methodCount: 0,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static init() {
    Logger.level = Level.debug;
//    Logger.level = Level.info;
  }

  static verbose(Object object) {
    logger.v(object);
  }

  static debug(Object object) {
    logger.d(object);
  }

  static info(Object object) {
    logger.i(object);
  }

  static warn(Object object) {
    logger.w(object);
  }

  static error(Object object) {
    logger.e(object);
  }
}
