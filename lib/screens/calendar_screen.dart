import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/plant.dart';
import '../services/plant_database_service.dart';
import '../services/zone_service.dart';
import 'monthly_guide_screen.dart';
import 'plant_detail_screen.dart';

/// "Planteringskalender" — vad ska göras vilken månad i din zon?
///
/// Tidigare design: en stor table-calendar (40% av skärmen) + en lång
/// vertikal lista av PlantCards (140px per card). Resultat: 2-3 växter
/// synliga på en skärm, sen oändlig scroll. Användaren såg aldrig
/// helheten för en månad.
///
/// Ny design: kompakt månadsväljare högst upp + fyra fas-sektioner
/// (Förodla / Direktså / Plantera ut / Skörd) renderade som
/// mini-chips i ett wrap-grid. En typisk månad rymmer 20-30 växter och
/// får plats utan scroll på en standard-skärm. Användaren ser med en
/// blick: "i mars kan jag förodla 12 saker, direktså 4, skörda 5."
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late int _month;

  @override
  void initState() {
    super.initState();
    _month = DateTime.now().month;
  }

  void _setMonth(int m) {
    setState(() {
      _month = ((m - 1) % 12 + 12) % 12 + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final zone = context.watch<ZoneService>();
    final db = context.watch<PlantDatabaseService>();

    // Fas-listor — dedup per Plant så samma växt inte dyker upp i två
    // sektioner när den t.ex. både kan förodlas och direktsås.
    final forsa = _dedup(db.forsaIMonth(_month, zone.zone));
    final direkt = _dedup(db.direktsaIMonth(_month, zone.zone));
    final plantera = _dedup(db.utplanteringIMonth(_month, zone.zone));
    final skord = _dedup(db.skordIMonth(_month, zone.zone));
    final total = forsa.length + direkt.length + plantera.length + skord.length;
    final monthLong = _capitalize(DateFormat.MMMM(localeName)
        .format(DateTime(DateTime.now().year, _month, 1)));

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F1),
        elevation: 0,
        title: Text(l10n.calendarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories),
            tooltip: l10n.calendarMonthGuide,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MonthlyGuideScreen(initialMonth: _month),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _MonthPicker(
            month: _month,
            onChange: _setMonth,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Row(
              children: [
                Text(
                  '$monthLong · ${l10n.gardensZoneLine(zone.zone.toString())}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D5016),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.calendarTaskCount(total.toString()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: total == 0
                ? _Empty(monthName: monthLong)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    children: [
                      _PhaseSection(
                        title: l10n.calendarPhasePresow,
                        emoji: '🏠',
                        accent: const Color(0xFF8E24AA),
                        plants: forsa,
                      ),
                      _PhaseSection(
                        title: l10n.calendarPhaseDirectsow,
                        emoji: '🌱',
                        accent: const Color(0xFF558B2F),
                        plants: direkt,
                      ),
                      _PhaseSection(
                        title: l10n.calendarPhasePlantout,
                        emoji: '🪴',
                        accent: const Color(0xFFEF6C00),
                        plants: plantera,
                      ),
                      _PhaseSection(
                        title: l10n.calendarPhaseHarvest,
                        emoji: '🥕',
                        accent: const Color(0xFFC62828),
                        plants: skord,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static List<Plant> _dedup(List<Plant> input) {
    final seen = <String>{};
    final out = <Plant>[];
    for (final p in input) {
      if (seen.add(p.id)) out.add(p);
    }
    out.sort((a, b) => a.namnSv.compareTo(b.namnSv));
    return out;
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// Horizontal scrollable month strip with the active month highlighted.
/// Compared to the old 40%-tall TableCalendar it occupies ~70px and
/// gives the user single-tap access to any month — most users only ever
/// jump 1-3 months in either direction anyway.
class _MonthPicker extends StatelessWidget {
  final int month;
  final ValueChanged<int> onChange;
  const _MonthPicker({required this.month, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final controller = ScrollController(
      // Center the active month on first build. The 56-wide cell × month
      // index gets us close to where it sits horizontally.
      initialScrollOffset: ((month - 1) * 60.0 - 100).clamp(
        0.0,
        // Math.max replacement — rough upper bound, ListView clamps anyway.
        (12 * 60.0),
      ),
    );
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => onChange(month - 1),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              itemBuilder: (_, i) {
                final m = i + 1;
                final selected = m == month;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: selected
                        ? const Color(0xFF558B2F)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onChange(m),
                      child: Container(
                        width: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF558B2F)
                                : const Color(0xFFCDE0AB),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat.MMM(localeName)
                              .format(DateTime(DateTime.now().year, m, 1))
                              .toLowerCase(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF2D5016),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => onChange(month + 1),
          ),
        ],
      ),
    );
  }
}

/// One phase block (e.g. "FÖRODLA INOMHUS · 12 växter") rendered as a
/// header + wrap of small plant chips. Hides entirely when the phase
/// has no plants for the active month + zone, so the user doesn't see
/// an empty "Direktså · 0 växter"-block in January.
class _PhaseSection extends StatelessWidget {
  final String title;
  final String emoji;
  final Color accent;
  final List<Plant> plants;
  const _PhaseSection({
    required this.title,
    required this.emoji,
    required this.accent,
    required this.plants,
  });

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDEDE2)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(emoji,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)
                      .calendarPhaseCount(plants.length.toString()),
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final p in plants) _PlantChip(plant: p, accent: accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact tappable plant chip — emoji + Swedish name in one pill.
/// Designed at ~32px tall so a phase with 15 plants still fits cleanly
/// in 3-4 wrap rows.
class _PlantChip extends StatelessWidget {
  final Plant plant;
  final Color accent;
  const _PlantChip({required this.plant, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAF8F1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlantDetailScreen(plant: plant),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6E2D2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(plant.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                plant.namnSv,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String monthName;
  const _Empty({required this.monthName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌨️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              l10n.calendarEmptyTitle(monthName),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.calendarEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
