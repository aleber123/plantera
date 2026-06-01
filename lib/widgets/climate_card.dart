import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../screens/paywall_screen.dart';
import '../services/premium_service.dart';
import '../services/weather_service.dart';

/// Premium "Klimatkort" — surfaces three signals serious gardeners
/// actually use to time succession sowing, fertilizing windows and
/// harvest expectations:
///
///   - **Medel-dygnstemp senaste 14 dagar** (°C). Anchor for "is the
///     soil warm enough", "are we in heat-stress range", etc.
///   - **Min/max-spann** (°C). Tells you about frost risk and heat
///     stress at the bookends of the day.
///   - **GDD ackumulerat** (Growing Degree Days, base 10°C). The
///     standard kitchen-garden number for crop maturity. A tomato
///     ripens after ~600 GDD; basil at ~150.
///
/// Free-version users see a teaser CTA instead. Hides entirely when
/// the historical data hasn't loaded yet (silently — the user
/// doesn't need a "loading temperature" placeholder).
class ClimateCard extends StatelessWidget {
  const ClimateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherService, PremiumService>(
      builder: (ctx, weather, premium, _) {
        final avg = weather.avgTempLast14d;
        // Hide entirely until we have data — better than a flicker.
        if (avg == null) return const SizedBox.shrink();

        if (!premium.isPremium) return const _ClimateTeaser();

        final mx = weather.maxTempLast14d;
        final mn = weather.minTempLast14d;
        final gdd = weather.gddLast14d;

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
                Row(
                  children: [
                    const Text('🌡️',
                        style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).climateCardTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2A1A),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _UpdatedChip(
                      updatedAt: weather.lastFetchedAt,
                      stale: weather.isStale,
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.workspace_premium,
                        size: 16, color: Color(0xFFF6A700)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ClimateStat(
                      label: AppLocalizations.of(context).climateStatAvg,
                      value: '${avg.toStringAsFixed(1)}°',
                      accent: 0xFF1976D2,
                    ),
                    const SizedBox(width: 8),
                    _ClimateStat(
                      label: AppLocalizations.of(context).climateStatMinMax,
                      value: mn != null && mx != null
                          ? '${mn.toStringAsFixed(0)}/${mx.toStringAsFixed(0)}°'
                          : '—',
                      accent: 0xFF558B2F,
                    ),
                    const SizedBox(width: 8),
                    _ClimateStat(
                      label: AppLocalizations.of(context).climateStatGdd,
                      value: gdd != null ? gdd.toStringAsFixed(0) : '—',
                      accent: 0xFFEF6C00,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _interpretGdd(context, gdd, avg),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Translates the raw GDD number into something a hobbyist actually
  /// gets. The thresholds are calibrated for a 14-day window in
  /// southern-mid Sweden during the growing season.
  String _interpretGdd(BuildContext context, double? gdd, double avg) {
    final l10n = AppLocalizations.of(context);
    if (gdd == null) return l10n.climateInterpretWaking;
    if (gdd < 30) return l10n.climateInterpretEarly;
    if (gdd < 100) return l10n.climateInterpretSpring;
    if (gdd < 200) return l10n.climateInterpretMidSpring;
    if (gdd < 350) return l10n.climateInterpretFullGrowth;
    return l10n.climateInterpretHot;
  }
}

/// Subtle freshness chip: "uppdaterad HH:MM", or an "offline"-flavoured
/// variant when the last fetch failed and we're showing stale data.
/// Strings are hardcoded Swedish to match the sv-only ASC listing —
/// adding l10n keys would require a gen-l10n run we can't do here.
class _UpdatedChip extends StatelessWidget {
  final DateTime? updatedAt;
  final bool stale;
  const _UpdatedChip({required this.updatedAt, required this.stale});

  @override
  Widget build(BuildContext context) {
    if (updatedAt == null) return const SizedBox.shrink();
    final t = updatedAt!;
    final hhmm = '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
    final label = stale ? 'offline · $hhmm' : 'uppdaterad $hhmm';
    final color =
        stale ? const Color(0xFF9A6A00) : Colors.grey.shade500;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          stale ? Icons.cloud_off : Icons.schedule,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ClimateStat extends StatelessWidget {
  final String label;
  final String value;
  final int accent;
  const _ClimateStat({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(accent);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClimateTeaser extends StatelessWidget {
  const _ClimateTeaser();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Material(
        color: const Color(0xFFFFF7E0),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => const PaywallScreen(source: 'frost')),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8D26A)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Row(
              children: [
                const Text('🌡️', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).climateTeaserTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A4F00),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).climateTeaserBody,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF5A3B00),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.workspace_premium,
                    color: Color(0xFFF6A700), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
