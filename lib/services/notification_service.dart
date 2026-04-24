import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/plant.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _enabled = true;
  int _morningHour = 8;

  static const String _enabledKey = 'notifications_enabled';
  static const String _morningHourKey = 'notification_morning_hour';

  static const String _channelId = 'plantera_main';
  static const String _channelName = 'Trädgårdspåminnelser';
  static const String _channelDesc =
      'Påminnelser om sådd, plantering, skörd och frost';

  bool get enabled => _enabled;
  int get morningHour => _morningHour;

  Future<void> initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_enabledKey) ?? true;
    _morningHour = prefs.getInt(_morningHourKey) ?? 8;
    _initialized = true;
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosOk = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidOk = await android?.requestNotificationsPermission() ?? true;
    return iosOk || androidOk;
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
    if (!value) await cancelAll();
    notifyListeners();
  }

  Future<void> setMorningHour(int hour) async {
    _morningHour = hour.clamp(5, 12);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_morningHourKey, _morningHour);
    notifyListeners();
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// Schedule a one-shot reminder for a specific plant action.
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    if (!_enabled) return;
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule sowing reminder for a plant at a given month/zone.
  Future<void> schedulePlantingReminder({
    required Plant plant,
    required int zone,
    required DateTime when,
    required String action,
  }) async {
    final id = _stableId('${plant.id}-$action-${when.year}-${when.month}');
    await scheduleOneShot(
      id: id,
      title: '${plant.kategori.emoji} ${plant.namnSv}',
      body: '$action är aktuellt i zon $zone',
      when: DateTime(when.year, when.month, when.day, _morningHour),
      payload: 'plant:${plant.id}',
    );
  }

  /// Schedule a frost warning for a specific date.
  Future<void> scheduleFrostWarning({
    required DateTime when,
    required double minTempC,
  }) async {
    final id = _stableId('frost-${when.year}-${when.month}-${when.day}');
    await scheduleOneShot(
      id: id,
      title: '❄️ Frostvarning i natt',
      body:
          'Minst ${minTempC.toStringAsFixed(0)}°C väntas – skydda känsliga växter.',
      when: DateTime(when.year, when.month, when.day, 18),
      payload: 'frost',
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();

  int _stableId(String key) {
    var hash = 0;
    for (final c in key.codeUnits) {
      hash = (hash * 31 + c) & 0x7fffffff;
    }
    return hash;
  }
}
