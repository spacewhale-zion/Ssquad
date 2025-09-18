import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static const String webBaseUrl = 'http://127.0.0.1:3000/api'; 
  static const String androidBaseUrl = 'http://10.0.2.2:3000/api';
  static const String iosBaseUrl = 'http://localhost:3000/api'; 

  static String get baseUrl {
    if (kIsWeb) {
      return webBaseUrl;
    } else if (Platform.isAndroid) {
      return androidBaseUrl;
    } else if (Platform.isIOS) {
      return iosBaseUrl;
    } else {
      return webBaseUrl;
    }
  }
}
