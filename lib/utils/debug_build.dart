import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether this build may show developer-only affordances (the hidden
/// debug menu in Settings).
///
/// ALWAYS false in an App Store production build, so anything gated on
/// this can never reach real users.
///
/// Detection:
///   - In debug mode it's trivially true.
///   - In release mode we ask iOS whether the App Store receipt is the
///     *sandbox* receipt. App Store production builds ship a "receipt";
///     TestFlight and Xcode-run builds ship a "sandboxReceipt". This is
///     automatic — there is no `--dart-define` flag to forget, which
///     could otherwise leak a debug menu into production.
///
/// Fails CLOSED: any channel error (e.g. Android, where the channel is
/// not registered) resolves to false, hiding the menu.
class DebugBuild {
  DebugBuild._();

  static const _channel =
      MethodChannel('com.alexanderbergqvist.plantera/debug');
  static bool? _cached;

  static Future<bool> isSandbox() async {
    if (kDebugMode) return true;
    final cached = _cached;
    if (cached != null) return cached;
    try {
      final v = await _channel.invokeMethod<bool>('isSandbox');
      _cached = v ?? false;
    } catch (_) {
      _cached = false; // fail closed — never reveal the menu on error
    }
    return _cached!;
  }
}
