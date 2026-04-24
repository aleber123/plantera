import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/affiliate_service.dart';
import '../services/garden_service.dart';
import '../services/notification_service.dart';
import '../services/zone_service.dart';
import '../utils/constants.dart';
import '../widgets/affiliate_card.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;
  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final zone = context.watch<ZoneService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('${plant.kategori.emoji} ${plant.namnSv}'),
      ),
      body: ListView(
        children: [
          _headerBanner(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.namnLat,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                Text(plant.beskrivning, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 20),
                _infoGrid(context),
                const SizedBox(height: 20),
                _timeline(context),
                if (plant.instruktioner != null) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('📘 Så här gör du'),
                  Text(plant.instruktioner!),
                ],
                if (plant.tips != null) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('💡 Tips'),
                  Text(plant.tips!),
                ],
                if (plant.skadedjur.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('🐛 Skadedjur att bevaka'),
                  Wrap(
                    spacing: 6,
                    children: plant.skadedjur
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                if (!plant.zoner.contains(zone.zone))
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              'Denna växt är inte härdig i din zon (${zone.zone}). Odla i kruka eller växthus.'),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _addToGarden(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Lägg till i min trädgård'),
                  ),
                ),
              ],
            ),
          ),
          AffiliateCard(
            title: '🛒 Verktyg och tillbehör',
            products: AffiliateService.productsForPlant(plant),
          ),
        ],
      ),
    );
  }

  Widget _headerBanner(BuildContext ctx) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(plant.kategori.emoji,
          style: const TextStyle(fontSize: 72)),
    );
  }

  Widget _infoGrid(BuildContext ctx) {
    final items = [
      _info('☀️ Ljus', plant.solkrav.label),
      _info('💧 Vatten', plant.vattning.label),
      _info('🌿 Göd', plant.godselbehov.label),
      if (plant.jordPh != null) _info('⚗️ pH', plant.jordPh!),
      if (plant.avstandCm != null)
        _info('📏 Avstånd', '${plant.avstandCm} cm'),
      if (plant.djupCm != null) _info('⬇️ Djup', '${plant.djupCm} cm'),
      if (plant.dagarTillSkord != null)
        _info('📅 Dagar', '${plant.dagarTillSkord}'),
      _info('🌡️ Zoner',
          plant.zoner.map((z) => z.toString()).join(', ')),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items,
    );
  }

  Widget _info(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label: $value',
          style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _timeline(BuildContext ctx) {
    final rows = [
      ('Förså inomhus', plant.forsadatum),
      ('Direktså utomhus', plant.direktsadatum),
      ('Plantera ut', plant.utplanteringsdatum),
      ('Skörd', plant.skordeperiod),
    ].where((r) => r.$2 != null).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('📅 Säsong'),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(width: 160, child: Text(r.$1)),
                Text(_monthRange(r.$2!.startMonth, r.$2!.endMonth),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }

  String _monthRange(int start, int end) {
    final s = AppConstants.monthShortSv[start];
    final e = AppConstants.monthShortSv[end];
    if (start == end) return s;
    return '$s – $e';
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child:
            Text(t, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      );

  Future<void> _addToGarden(BuildContext context) async {
    final garden = context.read<GardenService>();
    final notifications = context.read<NotificationService>();
    final zone = context.read<ZoneService>();
    final msg = ScaffoldMessenger.of(context);

    await garden.add(plantId: plant.id, status: PlantStatus.forsadd);

    if (plant.forsadatum != null) {
      final now = DateTime.now();
      var month = plant.forsadatum!.startMonth;
      var year = now.year;
      if (month < now.month) year += 1;
      final when = DateTime(year, month, 1);
      await notifications.schedulePlantingReminder(
        plant: plant,
        zone: zone.zone,
        when: when,
        action: 'Förså',
      );
    }

    msg.showSnackBar(
      SnackBar(content: Text('${plant.namnSv} tillagd i din trädgård')),
    );
  }
}
