// import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environments {
  static String backendServiceBaseUrl = 'http://0.0.0.0:9000';
  static String appName = 'WeShot';
  static String showDebugBanner = 'false';
  static String stripePublishableKey = 'pk_test_51ORCLBKDKFDX2JEEBMdLEnVk9w3zzZLdc7ejt4WkDctkofiRjj6KUCzOiHSakJznIXTcIDpVPGlAXiGmPAek2Trr00ao6731v3';
  static String firebaseStripeFunctionUrl = 'https://us-central1-socialmedia-flutter-app.cloudfunctions.net/stripePaymentIntentRequest';
}
// abstract class Environments {
//   static String backendServiceBaseUrl = dotenv.env['BACKEND_SERVICE_BASE_URL'] ?? 'http://0.0.0.0:8000';
//   static String appName = dotenv.env['APP_NAME'] ?? 'WeShot';
//   static String showDebugBanner = dotenv.env['SHOW_DEBUG_BANNER'] ?? 'false';
// }