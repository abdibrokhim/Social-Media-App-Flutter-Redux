import 'package:logger/logger.dart';

class AppLog {
  static Logger log() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: false,
        printTime: true,
        noBoxingByDefault: true,
      ),
    );
  }
}
