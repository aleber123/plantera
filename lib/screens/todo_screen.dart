import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/garden_task.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../services/task_service.dart';
import '../utils/water_all.dart';
import 'plant_detail_screen.dart';

/// "Att göra" — the central inbox of the app. Replaces the previous
/// "Idag i trädgården"-card, "Kommande omsorg"-card, and
/// notification-only flow with a persistent state-machine the user
/// actually interacts with.
///
/// Design choices:
///   - Three time buckets (Idag / Denna vecka / Denna månad)
///   - Swipe right → done (haptic, animates out)
///   - Swipe left → snooze 1 dag
///   - Tap → opens the plant the task belongs to
///   - "Klart idag"-section at the bottom collapsible — gratification
///     + ability to undo
class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabTodo),
        actions: [
          IconButton(
            tooltip: l10n.myGardenWaterAllTooltip,
            icon: const Icon(Icons.water_drop_outlined),
            onPressed: () => waterAllOutdoorPlants(context),
          ),
        ],
      ),
      body: Consumer<TaskService>(
        builder: (ctx, taskService, _) {
          final all = taskService.tasks;
          if (all.isEmpty) return const _EmptyState();

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final weekEnd = today.add(const Duration(days: 7));
          final monthEnd = today.add(const Duration(days: 30));

          final pending = all.where((t) => t.status == TaskStatus.pending).toList();
          final done =
              all.where((t) => t.status == TaskStatus.done).toList();

          final todayList =
              pending.where((t) => t.isDueOnOrBefore(today)).toList();
          final weekList = pending
              .where((t) =>
                  !t.isDueOnOrBefore(today) &&
                  t.dueDate.isBefore(weekEnd.add(const Duration(days: 1))))
              .toList();
          final monthList = pending
              .where((t) =>
                  t.dueDate
                      .isAfter(weekEnd.subtract(const Duration(days: 1))) &&
                  t.dueDate.isBefore(monthEnd.add(const Duration(days: 1))))
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
            children: [
              _StatHeader(
                todayCount: todayList.length,
                weekCount: weekList.length,
                doneTodayCount: done.length,
              ),
              if (todayList.isNotEmpty) ...[
                _SectionHeader(
                    title: l10n.todoSectionToday, count: todayList.length),
                for (final t in todayList) _TaskTile(task: t),
              ],
              if (weekList.isNotEmpty) ...[
                _SectionHeader(
                    title: l10n.todoSectionWeek, count: weekList.length),
                for (final t in weekList) _TaskTile(task: t),
              ],
              if (monthList.isNotEmpty) ...[
                _SectionHeader(
                    title: l10n.todoSectionMonth, count: monthList.length),
                for (final t in monthList) _TaskTile(task: t),
              ],
              if (done.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionHeader(
                    title: l10n.todoSectionDoneToday,
                    count: done.length,
                    muted: true),
                for (final t in done) _TaskTile(task: t),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('☀️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              l10n.todoEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.todoEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatHeader extends StatelessWidget {
  final int todayCount;
  final int weekCount;
  final int doneTodayCount;
  const _StatHeader({
    required this.todayCount,
    required this.weekCount,
    required this.doneTodayCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _Stat(value: '$todayCount', label: l10n.todoStatToday),
          const SizedBox(width: 8),
          _Stat(value: '$weekCount', label: l10n.todoStatWeek),
          const SizedBox(width: 8),
          _Stat(
              value: '$doneTodayCount',
              label: l10n.todoStatDone,
              accent: 0xFF558B2F),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final int? accent;
  const _Stat({required this.value, required this.label, this.accent});

  @override
  Widget build(BuildContext context) {
    final color = accent != null ? Color(accent!) : const Color(0xFF1F2A1A);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                )),
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.75),
                )),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool muted;
  const _SectionHeader(
      {required this.title, required this.count, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final color =
        muted ? Colors.grey.shade500 : const Color(0xFF2D5016);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatefulWidget {
  final GardenTask task;
  const _TaskTile({required this.task});

  @override
  State<_TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<_TaskTile> {
  // True while a complete/snooze is being persisted. The tap-circle and
  // swipe gesture can both fire on the same row in quick succession
  // (e.g. tap the circle then immediately swipe), double-completing,
  // double-marking-watered, and double-firing haptics. This flag locks
  // the row for the duration of the in-flight action.
  bool _busy = false;

  Future<void> _complete() async {
    if (_busy) return;
    setState(() => _busy = true);
    final svc = context.read<TaskService>();
    final messenger = ScaffoldMessenger.of(context);
    HapticFeedback.mediumImpact();
    await svc.complete(widget.task);
    // Confirmation only — a water completion also bumps lastWatered, which
    // isn't cleanly reversible, so no "Ångra" here. The "Klart idag"-row
    // still surfaces it for the rest of the day.
    messenger
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(
        content: Text('Klart!'),
        duration: Duration(seconds: 2),
      ));
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _snooze() async {
    if (_busy) return;
    setState(() => _busy = true);
    final svc = context.read<TaskService>();
    final messenger = ScaffoldMessenger.of(context);
    HapticFeedback.lightImpact();
    await svc.snooze(widget.task);
    final captured = widget.task;
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: const Text('Skjuten 1 dag'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Ångra',
          onPressed: () => svc.undoSnooze(captured),
        ),
      ));
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final accent = Color(task.kind.accentArgb);
    final isDone = task.status == TaskStatus.done;
    return Dismissible(
      key: ValueKey(task.key),
      direction: (isDone || _busy)
          ? DismissDirection.none
          : DismissDirection.horizontal,
      background: Container(
        color: const Color(0xFF558B2F),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const Icon(Icons.check, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).todoSwipeDone,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: const Color(0xFFEF6C00),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context).todoSwipeSnooze,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.snooze, color: Colors.white, size: 28),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (_busy) return false;
        if (direction == DismissDirection.startToEnd) {
          await _complete();
        } else if (direction == DismissDirection.endToStart) {
          await _snooze();
        }
        // Always return false — the Consumer rebuild handles the
        // visual removal via _regenerate, so the tile re-renders
        // already without it. Returning true would double-animate.
        return false;
      },
      child: _TaskRow(
        task: task,
        accent: accent,
        isDone: isDone,
        busy: _busy,
        onComplete: _complete,
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final GardenTask task;
  final Color accent;
  final bool isDone;
  final bool busy;
  final Future<void> Function() onComplete;
  const _TaskRow({
    required this.task,
    required this.accent,
    required this.isDone,
    required this.busy,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDone
          ? Colors.grey.shade50
          : Colors.white,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDone ? 0.06 : 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(task.emoji,
                    style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDone
                            ? Colors.grey.shade500
                            : const Color(0xFF1F2A1A),
                        decoration:
                            isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.body != null && task.body!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.body!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Tappable check-circle on the right edge so the user can
              // mark a task done without learning the swipe-right
              // gesture. Earlier versions left this as a static circle
              // and users tapping it (or the row) got navigated to the
              // plant detail without anything actually being marked
              // done — confusing for the most-common flow.
              if (isDone)
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.check_circle,
                      color: Color(0xFF558B2F), size: 22),
                )
              else
                Semantics(
                  button: true,
                  label: AppLocalizations.of(context).todoSwipeDone,
                  child: InkResponse(
                    onTap: () async {
                      // In-flight guard: the swipe gesture and this circle
                      // can both fire on the same row otherwise.
                      if (busy) return;
                      // Existence guard (mirrors _handleTap): a task can
                      // reference a plant the user just deleted in another
                      // tab. Completing it would write an orphan completion
                      // row for a plant that no longer exists.
                      if (!_plantStillExists(context)) return;
                      await onComplete();
                    },
                    radius: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: task.priority == TaskPriority.high
                          ? Icon(Icons.radio_button_unchecked,
                              color: accent, size: 24)
                          : Icon(Icons.radio_button_unchecked,
                              color: Colors.grey.shade400, size: 24),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// True if the task's plant still exists (or the task is a generic
  /// chore with no plant). Guards tap-to-complete against orphan
  /// completion rows for plants deleted in another tab.
  bool _plantStillExists(BuildContext context) {
    final id = task.gardenPlantId;
    if (id == null) return true; // generic chore — no plant to check
    final garden = context.read<GardenService>();
    return garden.allPlants.any((g) => g.id == id);
  }

  Future<void> _handleTap(BuildContext context) async {
    // Generic chores (e.g. "Rensa runt buskar" from monthly_chores.json)
    // have no associated plant — show a detail sheet with the body
    // and a "Markera som klar"-button instead of silently failing.
    final id = task.gardenPlantId;
    if (id == null) {
      await _showChoreSheet(context);
      return;
    }
    final garden = context.read<GardenService>();
    final db = context.read<PlantDatabaseService>();
    GardenPlant? gp;
    for (final g in garden.allPlants) {
      if (g.id == id) {
        gp = g;
        break;
      }
    }
    // Plant deleted or task references a stale id — fall back to the
    // chore-style sheet so the tap still surfaces the description.
    if (gp == null) {
      if (!context.mounted) return;
      await _showChoreSheet(context);
      return;
    }
    final plant = db.byId(gp.plantId);
    if (plant == null) {
      if (!context.mounted) return;
      await _showChoreSheet(context);
      return;
    }
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantDetailScreen(plant: plant, gardenPlant: gp),
      ),
    );
  }

  Future<void> _showChoreSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final accent = Color(task.kind.accentArgb);
    final isDone = task.status == TaskStatus.done;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(task.emoji,
                        style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                  ),
                ],
              ),
              if (task.body != null && task.body!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  task.body!,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    color: Color(0xFF1F2A1A),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (!isDone)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF558B2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    await ctx.read<TaskService>().complete(task);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.check),
                  label: Text(
                    l10n.todoSwipeDone,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Color(0xFF558B2F), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          l10n.todoSectionDoneToday,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF558B2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
