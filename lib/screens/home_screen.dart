import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/affiliate_service.dart';
import '../services/garden_service.dart';
import '../services/premium_service.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';
import 'gardens_screen.dart';
import '../utils/theme.dart';
import '../widgets/affiliate_card.dart';
import '../widgets/climate_card.dart';
import '../widgets/dry_period_banner.dart';
import '../widgets/garden_overview_card.dart';
import '../widgets/season_planner_card.dart';
import '../widgets/weather_card.dart';
import 'paywall_screen.dart';

/// "Hem" is now the **context** surface — what's the world doing
/// today (weather, frost, dry periods) and what's coming up (säsong-
/// planeraren). Action lives on the "Att göra"-tab; the canonical
/// garden view lives on "Mina växter". Earlier this screen held
/// "Min trädgård just nu", DailyInsights and UpcomingCare which all
/// duplicated content from those other tabs — they've been removed.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _GardenSwitcherTitle(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final zone = context.read<ZoneService>();
          if (zone.lat != null && zone.lon != null) {
            await context
                .read<WeatherService>()
                .fetch(zone.lat!, zone.lon!, force: true);
          }
        },
        child: Consumer2<ZoneService, WeatherService>(
          builder: (ctx, zone, weather, _) {
            final showFrostCard = weather.nextFrostDay != null;
            return ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                // Time-to-harvest progress (different from the
                // "Mina växter"-tab which is the canonical garden
                // list — this is just "när blir det skörd").
                const GardenOverviewCard(),

                // Acute weather signals.
                const DryPeriodBanner(),
                WeatherCard(weather: weather, zone: zone),

                // Klimat-kort: medel-dygnstemp + GDD (Premium).
                const ClimateCard(),

                // Plan ahead — season planner.
                const SeasonPlannerCard(),

                // Conditional CTAs.
                if (showFrostCard)
                  AffiliateCard(
                    title: AppLocalizations.of(ctx).frostCardTitle,
                    products: AffiliateService.frostProducts(),
                  ),
                _premiumTeaser(ctx),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _premiumTeaser(BuildContext ctx) {
    final premium = ctx.watch<PremiumService>();
    if (premium.isPremium) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: InkWell(
        onTap: () => Navigator.of(ctx).push(
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7CB342), Color(0xFF558B2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(ctx).premiumTeaserTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(ctx).premiumTeaserBody,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tappable AppBar title showing the active garden's emoji + name.
/// Tapping opens a bottom-sheet with all gardens; user picks one →
/// active state switches and the entire app re-scopes (plants, weather,
/// stats, notifications all follow the active garden).
class _GardenSwitcherTitle extends StatelessWidget {
  const _GardenSwitcherTitle();

  @override
  Widget build(BuildContext context) {
    final garden = context.watch<GardenService>();
    final active = garden.activeGarden;
    final hasMultiple = garden.gardens.length > 1;

    if (active == null) return const Text('Plantera');

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showSwitcher(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(active.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(active.name,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800)),
            if (hasMultiple) ...[
              const SizedBox(width: 4),
              const Icon(Icons.expand_more, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showSwitcher(BuildContext context) async {
    final svc = context.read<GardenService>();
    final action = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
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
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context).gardensSwitcherTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),
              for (final g in svc.gardens)
                ListTile(
                  leading:
                      Text(g.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(g.name,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(
                      '${g.city ?? AppLocalizations.of(context).gardensNoLocation} · ${AppLocalizations.of(context).gardensZoneLine(g.zone.toString())}'),
                  trailing: g.id == svc.activeGardenId
                      ? const Icon(Icons.check_circle,
                          color: Color(0xFF558B2F))
                      : null,
                  onTap: () => Navigator.pop(ctx, g.id),
                ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add, color: Color(0xFF558B2F)),
                title: Text(
                  AppLocalizations.of(context).gardensAddNew,
                  style: const TextStyle(
                      color: Color(0xFF558B2F),
                      fontWeight: FontWeight.w700),
                ),
                onTap: () => Navigator.pop(ctx, '__add__'),
              ),
              ListTile(
                leading: const Icon(Icons.tune),
                title: Text(AppLocalizations.of(context).gardensManage),
                onTap: () => Navigator.pop(ctx, '__manage__'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    if (action == '__add__' || action == '__manage__') {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GardensScreen()),
      );
    } else {
      await svc.setActiveGarden(action);
    }
  }
}
