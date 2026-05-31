import '../models/daily_insight.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../models/weather.dart';
import '../utils/zone_shift.dart';

/// Computes a ranked list of "what to do today" insights from the user's
/// garden, the plant database, and the SMHI forecast. Pure function — no
/// state, no side effects.
class InsightsService {
  static List<DailyInsight> compute({
    required List<GardenPlant> garden,
    required Plant? Function(String plantId) plantLookup,
    required List<WeatherDay> forecast,
    required int zone,
  }) {
    final insights = <DailyInsight>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayWeather = forecast.isEmpty ? null : forecast.first;

    insights.addAll(_frostTonight(garden, plantLookup, forecast, today));
    insights.addAll(_harvestReady(garden, plantLookup, now, zone));
    insights.addAll(_watering(garden, plantLookup, today, todayWeather));
    insights.addAll(_plantOut(garden, plantLookup, now, today, zone));
    insights.addAll(_heatwave(garden, forecast, today));

    insights.sort((a, b) => a.urgency.index.compareTo(b.urgency.index));
    return insights;
  }

  static Iterable<DailyInsight> _frostTonight(
    List<GardenPlant> garden,
    Plant? Function(String) plantLookup,
    List<WeatherDay> forecast,
    DateTime today,
  ) sync* {
    if (forecast.isEmpty) return;
    final tomorrow = today.add(const Duration(days: 1));
    WeatherDay? night;
    for (final d in forecast.take(2)) {
      final ds = DateTime(d.date.year, d.date.month, d.date.day);
      if (ds == today || ds == tomorrow) {
        if (night == null || d.minTempC < night.minTempC) night = d;
      }
    }
    if (night == null || !night.isFrostRisk) return;

    final sensitive = <Plant>[];
    for (final gp in garden) {
      if (gp.status != PlantStatus.utplanterad) continue;
      final p = plantLookup(gp.plantId);
      if (p != null && p.isFrostSensitive(night.minTempC)) sensitive.add(p);
    }
    if (sensitive.isEmpty) return;

    final names = sensitive
        .map((p) => p.namnSv.toLowerCase())
        .take(3)
        .join(', ');
    final more = sensitive.length > 3 ? ' m.fl.' : '';
    final temp = night.minTempC.toStringAsFixed(0);
    yield DailyInsight(
      emoji: '❄️',
      title: 'Frost i natt',
      body: '$temp°C väntas — täck $names$more',
      urgency: InsightUrgency.high,
    );
  }

  static Iterable<DailyInsight> _harvestReady(
    List<GardenPlant> garden,
    Plant? Function(String) plantLookup,
    DateTime now,
    int zone,
  ) sync* {
    final today = DateTime(now.year, now.month, now.day);
    for (final gp in garden) {
      final p = plantLookup(gp.plantId);
      if (p == null) continue;

      bool isReady;
      if (gp.status == PlantStatus.skordeklar) {
        // User explicitly marked it ready — trust them.
        isReady = true;
      } else if (gp.status == PlantStatus.utplanterad ||
          gp.status == PlantStatus.direktsadd) {
        // Zone-aware: harvest "starts" the database start_manad, but
        // the effective start day is shifted by ZoneShift.daysFor.
        // Without this a jordgubbe in zone 6 fires a "skörda"-insight
        // on June 1 even though the actual harvest there is mid-juli.
        final range = p.skordeperiod;
        if (range == null) {
          isReady = false;
        } else {
          final shiftedStart =
              ZoneShift.shiftSeasonStart(now.year, range.startMonth, zone);
          final pastShiftedStart = !today.isBefore(shiftedStart);
          final stillInSeasonMonth = range.includes(now.month);
          if (!pastShiftedStart || !stillInSeasonMonth) {
            isReady = false;
          } else {
            final plantedDay = DateTime(gp.plantedDate.year,
                gp.plantedDate.month, gp.plantedDate.day);
            final daysGrown = today.difference(plantedDay).inDays;
            final lifecycle = p.livscykel;
            final isLongLived = lifecycle == PlantLifecycle.perennial ||
                lifecycle == PlantLifecycle.tree ||
                lifecycle == PlantLifecycle.shrub;
            if (isLongLived) {
              isReady = true;
            } else if (p.dagarTillSkord != null) {
              isReady = daysGrown >= (p.dagarTillSkord! * 0.8).round();
            } else {
              isReady = daysGrown >= 30;
            }
          }
        }
      } else {
        isReady = false;
      }
      if (!isReady) continue;

      // Ornamentals get a "blomning"-insight instead of a harvest one
      // — users grow flowers to look at, not to pick.
      final isFlower = p.kategori == PlantCategory.blommor;
      final displayName = (gp.customName ?? p.namnSv).toLowerCase();
      yield DailyInsight(
        emoji: p.emoji,
        title: isFlower
            ? 'Blomning: $displayName'
            : 'Skörda $displayName',
        body: isFlower
            ? 'Njut — blomningen pågår'
            : gp.status == PlantStatus.skordeklar
                ? 'Markerad som skördeklar — dags!'
                : 'Skördeperioden är aktiv just nu',
        urgency: isFlower ? InsightUrgency.low : InsightUrgency.high,
        gardenPlantId: gp.id,
      );
    }
  }

  static Iterable<DailyInsight> _watering(
    List<GardenPlant> garden,
    Plant? Function(String) plantLookup,
    DateTime today,
    WeatherDay? todayWeather,
  ) sync* {
    // If significant rain today, no watering reminders.
    if (todayWeather != null && todayWeather.precipitationMm > 5) return;

    for (final gp in garden) {
      if (gp.status != PlantStatus.utplanterad) continue;
      final p = plantLookup(gp.plantId);
      if (p == null) continue;

      final ref = gp.lastWatered ?? gp.plantedDate;
      final refDay = DateTime(ref.year, ref.month, ref.day);
      final daysSince = today.difference(refDay).inDays;

      final threshold = switch (p.vattning) {
        WaterNeed.sparsam => 7,
        WaterNeed.regelbunden => 3,
        WaterNeed.riklig => 2,
      };
      if (daysSince < threshold) continue;

      final hot = todayWeather != null && todayWeather.maxTempC >= 22;
      final daysWord = daysSince == 1 ? 'dag' : 'dagar';
      yield DailyInsight(
        emoji: '💧',
        title: 'Vattna ${(gp.customName ?? p.namnSv).toLowerCase()}',
        body: gp.lastWatered == null
            ? 'Ej registrerad vattning ännu'
            : '$daysSince $daysWord sedan senast'
                '${hot ? ' • varmt idag' : ''}',
        urgency: hot ? InsightUrgency.high : InsightUrgency.medium,
        gardenPlantId: gp.id,
      );
    }
  }

  static Iterable<DailyInsight> _plantOut(
    List<GardenPlant> garden,
    Plant? Function(String) plantLookup,
    DateTime now,
    DateTime today,
    int zone,
  ) sync* {
    for (final gp in garden) {
      if (gp.status != PlantStatus.forsoddInne) continue;
      final p = plantLookup(gp.plantId);
      if (p == null) continue;
      // Zone-aware: northern users wait longer before planting out.
      final range = p.utplanteringsdatum;
      if (range == null) continue;
      if (!range.includes(now.month)) continue;
      final shiftedStart =
          ZoneShift.shiftSeasonStart(now.year, range.startMonth, zone);
      if (today.isBefore(shiftedStart)) continue;

      final sownDay = DateTime(
          gp.plantedDate.year, gp.plantedDate.month, gp.plantedDate.day);
      final daysSinceSowing = today.difference(sownDay).inDays;
      if (daysSinceSowing < 28) continue;

      yield DailyInsight(
        emoji: '🪴',
        title: 'Plantera ut ${(gp.customName ?? p.namnSv).toLowerCase()}',
        body: 'Plantorna har växt $daysSinceSowing dagar – '
            'utplanteringsmånaden är aktiv',
        urgency: InsightUrgency.medium,
        gardenPlantId: gp.id,
      );
    }
  }

  static Iterable<DailyInsight> _heatwave(
    List<GardenPlant> garden,
    List<WeatherDay> forecast,
    DateTime today,
  ) sync* {
    if (!garden.any((gp) => gp.status == PlantStatus.utplanterad)) return;
    var run = 0;
    WeatherDay? firstHot;
    for (final d in forecast) {
      if (d.maxTempC >= 25) {
        run++;
        firstHot ??= d;
        if (run >= 3) break;
      } else {
        run = 0;
        firstHot = null;
      }
    }
    if (run < 3 || firstHot == null) return;
    final firstDay =
        DateTime(firstHot.date.year, firstHot.date.month, firstHot.date.day);
    if (!firstDay.isAfter(today)) return;

    yield const DailyInsight(
      emoji: '🔥',
      title: 'Värmebölja på väg',
      body: 'Flera dagar över 25°C närmar sig — vattna noga och skugga '
          'känsliga växter',
      urgency: InsightUrgency.medium,
    );
  }
}
