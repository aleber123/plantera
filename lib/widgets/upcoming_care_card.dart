import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/monthly_chore.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/monthly_chores_service.dart';
import '../services/plant_database_service.dart';
import '../utils/constants.dart';

/// "Kommande omsorg" — merges two streams of seasonal advice:
///
/// 1. Plant-specific [CareTask]s for the user's actual garden (e.g.
///    "beskär äpple feb-mar", "klipp jordgubbsutlöpare aug").
/// 2. Generic monthly chores from `monthly_chores.json` (e.g. "rensa
///    rabatter april", "sätta vårblommande lökar september").
///
/// Both are surfaced together because, from the user's perspective,
/// "what should I do this month?" doesn't care about the source. The
/// row tag (växt-emoji vs allmän emoji) makes it clear what scope each
/// item belongs to.
///
/// Hidden entirely when there's literally nothing in the next month —
/// e.g. December's chore list is short and the user has zero plants.
class UpcomingCareCard extends StatelessWidget {
  const UpcomingCareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GardenService, PlantDatabaseService,
        MonthlyChoresService>(
      builder: (ctx, garden, db, chores, _) {
        if (!chores.loaded) return const SizedBox.shrink();
        final items = _collectItems(garden, db, chores);
        if (items.isEmpty) return const SizedBox.shrink();

        final top = items.take(5).toList();
        final remaining = items.length - top.length;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEDEDE2)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🛠️', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text(
                      'Kommande omsorg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Det här är dags att göra denna och nästa månad.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in top) _CareRow(item: item),
                if (remaining > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+$remaining till',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Gather both streams, sort by month, return as flat list.
  List<_Item> _collectItems(GardenService garden,
      PlantDatabaseService db, MonthlyChoresService chores) {
    final today = DateTime.now();
    final thisMonth = today.month;
    final nextMonth = thisMonth == 12 ? 1 : thisMonth + 1;
    final months = {thisMonth, nextMonth};

    final out = <_Item>[];

    // Plant-specific care tasks. Dedup per (plantId, taskId) so the
    // user doesn't see "beskär äpple" twice if they have two apple
    // trees.
    final seen = <String>{};
    for (final gp in garden.plants) {
      final p = db.byId(gp.plantId);
      if (p == null) continue;
      for (final task in p.omsorg) {
        if (!months.contains(task.month.startMonth) &&
            !task.month.includes(thisMonth) &&
            !task.month.includes(nextMonth)) {
          continue;
        }
        final key = '${p.id}-${task.id}';
        if (!seen.add(key)) continue;
        out.add(_Item.fromCareTask(p, task));
      }
    }

    // Generic monthly chores — drop ones already represented by a
    // plant-specific care task with the same intent? Skip for now;
    // the wording is different enough and we want both visible.
    for (final c in chores.upcoming(now: today)) {
      out.add(_Item.fromChore(c));
    }

    // Sort: this month before next month, severity high first within
    // a month.
    out.sort((a, b) {
      final aThis = a.month == thisMonth ? 0 : 1;
      final bThis = b.month == thisMonth ? 0 : 1;
      if (aThis != bThis) return aThis - bThis;
      final aSev = _severityRank(a.severity);
      final bSev = _severityRank(b.severity);
      if (aSev != bSev) return bSev - aSev;
      return a.title.compareTo(b.title);
    });
    return out;
  }

  static int _severityRank(String s) =>
      switch (s) { 'high' => 2, 'medium' => 1, _ => 0 };
}

class _Item {
  final String emoji;
  final String title;
  final String description;
  final int month;
  final String severity;
  final String? plantName;

  _Item({
    required this.emoji,
    required this.title,
    required this.description,
    required this.month,
    required this.severity,
    this.plantName,
  });

  factory _Item.fromCareTask(Plant p, CareTask task) => _Item(
        emoji: p.emoji,
        title: task.title,
        description: task.description,
        month: task.month.startMonth,
        severity: task.severity,
        plantName: p.namnSv,
      );

  factory _Item.fromChore(MonthlyChore c) => _Item(
        emoji: c.emoji,
        title: c.title,
        description: c.description,
        month: c.month,
        severity: 'low',
      );
}

class _CareRow extends StatefulWidget {
  final _Item item;
  const _CareRow({required this.item});

  @override
  State<_CareRow> createState() => _CareRowState();
}

class _CareRowState extends State<_CareRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        AppConstants.monthShortSv[widget.item.month];
    final accent = widget.item.severity == 'high'
        ? const Color(0xFFE65100)
        : widget.item.severity == 'medium'
            ? const Color(0xFF558B2F)
            : Colors.grey.shade700;

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.item.emoji,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2A1A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.item.plantName != null)
                        Text(
                          widget.item.plantName!,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    monthLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  widget.item.description,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
