import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/garden_plant.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../services/premium_service.dart';
import 'paywall_screen.dart';
import 'plant_database_screen.dart';

class MyGardenScreen extends StatelessWidget {
  const MyGardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Min trädgård')),
      body: Consumer2<GardenService, PlantDatabaseService>(
        builder: (ctx, garden, db, _) {
          if (garden.plants.isEmpty) {
            return _empty(ctx);
          }
          return ListView.builder(
            itemCount: garden.plants.length,
            itemBuilder: (_, i) {
              final gp = garden.plants[i];
              final plant = db.byId(gp.plantId);
              if (plant == null) return const SizedBox.shrink();
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Text(plant.kategori.emoji),
                  ),
                  title: Text(gp.customName ?? plant.namnSv),
                  subtitle: Text(
                      '${_statusLabel(gp.status)} • Planterad ${DateFormat('d MMM').format(gp.plantedDate)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => garden.remove(gp.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
        label: const Text('Lägg till växt'),
      ),
    );
  }

  String _statusLabel(PlantStatus s) => switch (s) {
        PlantStatus.forsadd => 'Förodlas',
        PlantStatus.utplanterad => 'Utplanterad',
        PlantStatus.skordeklar => 'Skördeklar',
        PlantStatus.vilande => 'Vilar',
      };

  Widget _empty(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🪴', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          const Text('Din trädgård är tom',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Lägg till växter från databasen så börjar vi bygga din plantering.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _add(ctx),
            icon: const Icon(Icons.search),
            label: const Text('Bläddra i växtdatabasen'),
          ),
        ],
      ),
    );
  }

  void _add(BuildContext ctx) {
    final premium = ctx.read<PremiumService>();
    final garden = ctx.read<GardenService>();
    if (!premium.canAddGardenPlant(garden.plantCount)) {
      Navigator.of(ctx).push(
        MaterialPageRoute(builder: (_) => const PaywallScreen()),
      );
      return;
    }
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) => const PlantDatabaseScreen()),
    );
  }
}
