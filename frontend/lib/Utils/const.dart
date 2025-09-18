import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:3000/api';
    } else if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_URL'] ?? 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_URL'] ?? 'http://localhost:3000/api';
    } else {
      return dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:3000/api';
    }
  }
}
