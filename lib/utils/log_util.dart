import 'package:flutter_wan_android/constants/constants.dart';
import 'package:logger/logger.dart';

class Wanlog {
  static Logger logger = Logger();

  static void i(String msg) {
    if (Constant.debug) {
      logger.i(msg);
    }
  }

  static void d(String msg) {
    if (Constant.debug) logger.d(msg);
  }

  static void w(String msg) {
    if (Constant.debug) logger.w(msg);
  }

  static void e(String msg) {
    logger.e(msg);
  }
}
