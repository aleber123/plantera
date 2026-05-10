import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/monthly_chore.dart';

/// Loads the static monthly-chores list from the bundled JSON asset.
/// Read-only — there's no per-user customization yet (the assumption is
/// that "rensa rabatter i april" applies broadly enough across Sweden
/// that personalization isn't worth the complexity right now).
class MonthlyChoresService extends ChangeNotifier {
  static final MonthlyChoresService _instance =
      MonthlyChoresService._internal();
  factory MonthlyChoresService() => _instance;
  MonthlyChoresService._internal();

  List<MonthlyChore> _chores = const [];
  bool _loaded = false;

  List<MonthlyChore> get chores => List.unmodifiable(_chores);
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw =
          await rootBundle.loadString('assets/data/monthly_chores.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final list = (data['chores'] as List).cast<Map<String, dynamic>>();
      _chores = list.map(MonthlyChore.fromJson).toList();
      _loaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('MonthlyChoresService load failed: $e');
      _chores = const [];
      _loaded = true;
    }
  }

  /// Chores for a specific month (1-12). Returns [] if no chores tagged
  /// for that month.
  List<MonthlyChore> forMonth(int month) =>
      _chores.where((c) => c.month == month).toList();

  /// Chores for the current month + the next one, in chronological order.
  /// Used by the home card to look slightly ahead so the user doesn't
  /// miss tasks at month-end.
  List<MonthlyChore> upcoming({DateTime? now}) {
    final today = now ?? DateTime.now();
    final nextMonth = today.month == 12 ? 1 : today.month + 1;
    return [
      ...forMonth(today.month),
      ...forMonth(nextMonth),
    ];
  }
}
