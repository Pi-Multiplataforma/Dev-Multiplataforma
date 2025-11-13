import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String resolveImageUrl(String url) {

  if (url.startsWith('http')) {
    if (kIsWeb) {
      return url; 
    }

    try {
      if (Platform.isAndroid) {
        return url.replaceFirst('127.0.0.1', '10.0.2.2');
      }
    } catch (_) {

    }

    return url;
  }

  if (kIsWeb) {
    return 'http://127.0.0.1:3000$url';
  }

  try {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000$url';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:3000$url';
    } else {
      return 'http://localhost:3000$url';
    }
  } catch (_) {
    return 'http://127.0.0.1:3000$url'; // fallback seguro
  }
}