import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class BadgeService {
  static const _channel = MethodChannel('com.alexanderbergqvist.plantera/badge');

  static Future<void> clear() async {
    if (kIsWeb) return;
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod('setBadge', {'count': 0});
    } catch (_) {
      // Ignore — badge clearing is best-effort.
    }
  }
}
