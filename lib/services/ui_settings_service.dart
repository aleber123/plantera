import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-controlled UI preferences. Persists across launches.
/// `largeText` adds ~15 % to text scale for accessibility — applied via
/// MediaQuery override at the MaterialApp root.
class UISettingsService extends ChangeNotifier {
  static final UISettingsService _instance = UISettingsService._internal();
  factory UISettingsService() => _instance;
  UISettingsService._internal();

  static const _largeTextKey = 'ui_large_text';
  static const _introShownKey = 'ui_intro_shown';
  static const _simpleStatusKey = 'ui_simple_status';

  bool _largeText = false;
  bool _introShown = false;
  bool _simpleStatus = true;

  bool get largeText => _largeText;

  /// True once the user has seen the post-onboarding 3-step features
  /// intro. We don't want to show it again on every launch — but we
  /// also let the user re-read it from Inställningar.
  bool get introShown => _introShown;

  /// When true (default), the status picker on PlantDetail shows only
  /// three plain-language options ("Planerad" / "Växer" / "Skördad")
  /// with a "Fler alternativ"-toggle for the 7 detailed lifecycle
  /// states. Power users flip this off to skip the toggle.
  bool get simpleStatus => _simpleStatus;

  /// Effective text scale to apply on top of the system scale.
  double get textScale => _largeText ? 1.15 : 1.0;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _largeText = prefs.getBool(_largeTextKey) ?? false;
    _introShown = prefs.getBool(_introShownKey) ?? false;
    _simpleStatus = prefs.getBool(_simpleStatusKey) ?? true;
    notifyListeners();
  }

  Future<void> setLargeText(bool value) async {
    if (_largeText == value) return;
    _largeText = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largeTextKey, value);
    notifyListeners();
  }

  Future<void> setIntroShown(bool value) async {
    if (_introShown == value) return;
    _introShown = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introShownKey, value);
    notifyListeners();
  }

  Future<void> setSimpleStatus(bool value) async {
    if (_simpleStatus == value) return;
    _simpleStatus = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_simpleStatusKey, value);
    notifyListeners();
  }
}
