import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../services/affiliate_service.dart';
import '../services/plant_database_service.dart';
import '../services/premium_service.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';
import '../utils/constants.dart';
import '../widgets/affiliate_card.dart';
import '../widgets/plant_card.dart';
import '../widgets/weather_card.dart';
import 'monthly_guide_screen.dart';
import 'paywall_screen.dart';
import 'plant_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantera')),
      body: RefreshIndicator(
        onRefresh: () async {
          final zone = context.read<ZoneService>();
          if (zone.lat != null && zone.lon != null) {
            await context
                .read<WeatherService>()
                .fetch(zone.lat!, zone.lon!, force: true);
          }
        },
        child: Consumer3<PlantDatabaseService, ZoneService, WeatherService>(
          builder: (ctx, db, zone, weather, _) {
            final month = DateTime.now().month;
            final forsa = db.forsaIMonth(month, zone.zone).take(5).toList();
            final direkt = db.direktsaIMonth(month, zone.zone).take(5).toList();
            final utplant =
                db.utplanteringIMonth(month, zone.zone).take(5).toList();
            final skord = db.skordIMonth(month, zone.zone).take(5).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                WeatherCard(weather: weather, zone: zone),
                _guideTeaser(ctx, month),
                if (weather.nextFrostDay != null)
                  AffiliateCard(
                    title: '❄️ Skydda mot frosten',
                    products: AffiliateService.frostProducts(),
                  ),
                _section(ctx, '🌱 Förså inomhus i ${_monthLabel(month)}', forsa),
                _section(
                    ctx, '🌾 Direktså i ${_monthLabel(month)}', direkt),
                _section(
                    ctx, '🪴 Plantera ut i ${_monthLabel(month)}', utplant),
                _section(ctx, '🥕 Skörda i ${_monthLabel(month)}', skord),
                if (forsa.isNotEmpty)
                  AffiliateCard(
                    title: '🌱 Kom igång med förså',
                    products: AffiliateService.forsaProducts(),
                  ),
                _premiumTeaser(ctx),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _section(BuildContext ctx, String title, List<Plant> plants) {
    if (plants.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        ...plants.map(
          (p) => PlantCard(
            plant: p,
            onTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(
                  builder: (_) => PlantDetailScreen(plant: p)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _premiumTeaser(BuildContext ctx) {
    final premium = ctx.watch<PremiumService>();
    if (premium.isPremium) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        color: Colors.green.shade50,
        child: ListTile(
          leading: const Icon(Icons.workspace_premium, color: Colors.amber),
          title: const Text('Plantera Premium'),
          subtitle: const Text(
              'Obegränsad trädgård, alla påminnelser, inga annonser'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => Navigator.of(ctx).push(
            MaterialPageRoute(builder: (_) => const PaywallScreen()),
          ),
        ),
      ),
    );
  }

  Widget _guideTeaser(BuildContext ctx, int month) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFFEFF6E5),
      child: ListTile(
        leading: const Icon(Icons.auto_stories, color: Color(0xFF2D5016)),
        title: Text('Månadens odlingsguide – ${_monthLabel(month)}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text(
            'Förså, direktså, skötsel och experttips för månaden'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => Navigator.of(ctx).push(
          MaterialPageRoute(
              builder: (_) => MonthlyGuideScreen(initialMonth: month)),
        ),
      ),
    );
  }

  String _monthLabel(int m) => AppConstants.monthNamesSv[m];
}
