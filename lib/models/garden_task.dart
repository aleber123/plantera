/// One actionable thing the user should do — water, fertilize, prune,
/// harvest, sow, etc. Replaces the previous "fire-and-forget"
/// notification model with a persistent state-machine: a task lives
/// from `pending` until the user marks it `done` (or snoozes it), at
/// which point it moves out of the active list and into history.
///
/// Tasks are mostly *generated* on-the-fly by [TaskService] from the
/// current garden state (water cadence, plant.omsorg, monthly_chores,
/// lifecycle phases). The only thing we persist between sessions is
/// the state changes the user has applied — completions and snoozes —
/// so a fresh app launch can re-derive the active list and skip
/// already-handled work.
///
/// The deterministic [key] field is the join point: regenerating the
/// "vattna basilika 2026-05-10"-task tomorrow would build the same
/// key, so a completion logged today silences it. Keys include date
/// granularity for daily tasks (water) and month for cadence-based
/// ones (fertilize).
class GardenTask {
  /// Stable, deterministic identifier — encodes kind, plantId/scope,
  /// and a date bucket. Same task generated next session produces the
  /// same key.
  ///
  /// Examples:
  ///   - water-{gardenPlantId}-{yyyy-MM-dd}
  ///   - fertilize-{gardenPlantId}-{yyyy-MM}
  ///   - care-{gardenPlantId}-{omsorgId}-{year}
  ///   - chore-{choreId}-{year}-{month}
  ///   - harvest-{gardenPlantId}-{year}
  ///   - sow-direct-{gardenPlantId}-{year}
  final String key;

  final TaskKind kind;
  final String title;
  final String? body;
  final String emoji;
  final DateTime dueDate;
  final TaskPriority priority;

  /// Garden plant this task belongs to. Null for general chores like
  /// "rensa rabatter" that apply to the whole garden.
  final String? gardenPlantId;
  /// Garden (multi-trädgård scope). Tasks are filtered by active garden
  /// in the UI; null = applies to whichever garden the user is in.
  final String? gardenId;

  /// State applied by the user. Computed at generation time by joining
  /// the task key against the persisted completions/snoozes tables.
  final TaskStatus status;
  final DateTime? completedAt;
  final DateTime? snoozedUntil;

  const GardenTask({
    required this.key,
    required this.kind,
    required this.title,
    this.body,
    required this.emoji,
    required this.dueDate,
    this.priority = TaskPriority.normal,
    this.gardenPlantId,
    this.gardenId,
    this.status = TaskStatus.pending,
    this.completedAt,
    this.snoozedUntil,
  });

  /// Stable identity used for SNOOZE lookups.
  ///
  /// Water-task keys encode a daily date, which changes each day for
  /// plants without a recorded `lastWatered` (the snooze stored against
  /// today's key wouldn't match tomorrow's regenerated key, so the task
  /// reappeared the next morning). Folding the date out for water tasks
  /// lets a snooze persist across the regenerate cycle until its
  /// `snoozedUntil` expires.
  ///
  /// For other task kinds (harvest, care, chore, sow, plant-out) the
  /// key already only encodes the year, so the raw key works fine.
  String get snoozeIdentity {
    if (kind == TaskKind.water && gardenPlantId != null) {
      return 'water-$gardenPlantId';
    }
    return key;
  }

  /// True if the task should appear in *today's* list (or earlier).
  bool isDueOnOrBefore(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return !due.isAfter(d);
  }

  /// Days from `from` until `dueDate` (negative = overdue).
  int daysUntilDue(DateTime from) {
    final f = DateTime(from.year, from.month, from.day);
    final d = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return d.difference(f).inDays;
  }

  GardenTask withStatus({
    required TaskStatus status,
    DateTime? completedAt,
    DateTime? snoozedUntil,
  }) =>
      GardenTask(
        key: key,
        kind: kind,
        title: title,
        body: body,
        emoji: emoji,
        dueDate: dueDate,
        priority: priority,
        gardenPlantId: gardenPlantId,
        gardenId: gardenId,
        status: status,
        completedAt: completedAt,
        snoozedUntil: snoozedUntil,
      );
}

enum TaskKind {
  /// Watering due based on plant.vattning + lastWatered cadence.
  water,
  /// Fertilizing — typically once a month for high-feed plants.
  fertilize,
  /// Pruning task from plant.omsorg.
  prune,
  /// Harvest is open AND plant has matured.
  harvest,
  /// Ornamental flowers in bloom — informational "njut av blomningen"
  /// reminder rather than a harvest. Same window as skordeperiod but
  /// the user grows them to look at, not to pick.
  bloom,
  /// Förodla / direktså / utplantering — phase reminders that today's
  /// notification system fires. They get folded into tasks too.
  sow,
  plantOut,
  hardenOff,
  /// Generic care task from plant.omsorg (catches everything that
  /// isn't water/fertilize/prune — e.g. "Klipp utlöpare", "Sätt upp
  /// fågelnät", "Stötta tunga grenar").
  careTask,
  /// Generic monthly chore from monthly_chores.json — applies to the
  /// whole garden, not a specific plant.
  monthlyChore,
  /// Pest scan suggestion (triggered when a plant has frequent pests
  /// in its database entry).
  pestCheck,
  /// User-created custom task. Future feature — placeholder.
  custom,
}

extension TaskKindLabel on TaskKind {
  /// Color hint for the swipe-row accent. Higher importance = warmer.
  int get accentArgb {
    switch (this) {
      case TaskKind.water:
        return 0xFF1976D2; // blue
      case TaskKind.fertilize:
        return 0xFF8E24AA; // purple
      case TaskKind.prune:
        return 0xFFEF6C00; // orange
      case TaskKind.harvest:
        return 0xFFC62828; // red
      case TaskKind.bloom:
        return 0xFFE91E63; // pink — ornamental
      case TaskKind.sow:
      case TaskKind.plantOut:
      case TaskKind.hardenOff:
        return 0xFF558B2F; // green
      case TaskKind.careTask:
        return 0xFF6D4C41; // brown
      case TaskKind.monthlyChore:
        return 0xFF455A64; // grey-blue
      case TaskKind.pestCheck:
        return 0xFFE65100; // amber
      case TaskKind.custom:
        return 0xFF558B2F;
    }
  }
}

enum TaskStatus {
  pending,
  done,
  snoozed,
}

enum TaskPriority {
  normal,
  high,
  urgent,
}

/// Persistence row for a completed task. Stored in `task_completions`.
/// Survives app restarts so the same generated task doesn't re-appear
/// in tomorrow's list.
class TaskCompletion {
  final String key;
  final DateTime completedAt;

  const TaskCompletion({required this.key, required this.completedAt});

  Map<String, Object?> toMap() => {
        'task_key': key,
        'completed_at': completedAt.millisecondsSinceEpoch,
      };

  factory TaskCompletion.fromMap(Map<String, Object?> m) => TaskCompletion(
        key: m['task_key'] as String,
        completedAt:
            DateTime.fromMillisecondsSinceEpoch(m['completed_at'] as int),
      );
}

class TaskSnooze {
  final String key;
  final DateTime snoozedUntil;

  const TaskSnooze({required this.key, required this.snoozedUntil});

  Map<String, Object?> toMap() => {
        'task_key': key,
        'snoozed_until': snoozedUntil.millisecondsSinceEpoch,
      };

  factory TaskSnooze.fromMap(Map<String, Object?> m) => TaskSnooze(
        key: m['task_key'] as String,
        snoozedUntil:
            DateTime.fromMillisecondsSinceEpoch(m['snoozed_until'] as int),
      );
}
