import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/harvest_entry.dart';
import '../services/harvest_service.dart';

/// Compact "Skördejournal"-summary card. Shown on the home screen when
/// the user has logged any harvest. Displays this year's totals per unit
/// and a delta vs. last year.
class HarvestYearlySummary extends StatelessWidget {
  const HarvestYearlySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HarvestService>(
      builder: (ctx, harvest, _) {
        if (!harvest.loaded || harvest.entries.isEmpty) {
          return const SizedBox.shrink();
        }
        final byYear = harvest.totalsByYear();
        final years = byYear.keys.toList()..sort();
        final thisYear = DateTime.now().year;
        final current = byYear[thisYear] ?? const <HarvestUnit, double>{};
        if (current.isEmpty) return const SizedBox.shrink();
        final last = byYear[thisYear - 1];

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🥕', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      'Skördejournal — $thisYear',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: current.entries.map((e) {
                    final lastVal = last?[e.key];
                    return _StatTile(
                      unit: e.key,
                      thisYear: e.value,
                      lastYear: lastVal,
                    );
                  }).toList(),
                ),
                if (years.length > 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Du loggar för år ${years.length} — fortsätt så!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
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
}

class _StatTile extends StatelessWidget {
  final HarvestUnit unit;
  final double thisYear;
  final double? lastYear;
  const _StatTile({
    required this.unit,
    required this.thisYear,
    this.lastYear,
  });

  @override
  Widget build(BuildContext context) {
    String? deltaLabel;
    Color? deltaColor;
    if (lastYear != null && lastYear! > 0) {
      final pct = ((thisYear - lastYear!) / lastYear! * 100).round();
      if (pct > 0) {
        deltaLabel = '+$pct% mot $lastYear ${unit.label}';
        deltaColor = Colors.green.shade700;
      } else if (pct < 0) {
        deltaLabel = '$pct% mot $lastYear ${unit.label}';
        deltaColor = Colors.orange.shade700;
      } else {
        deltaLabel = 'Samma som ifjol';
        deltaColor = Colors.grey.shade700;
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_fmt(thisYear)} ${unit.label}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF8D6E00),
            ),
          ),
          if (deltaLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              deltaLabel,
              style: TextStyle(fontSize: 11, color: deltaColor),
            ),
          ],
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(
        RegExp(r'\.$'), '');
  }
}
