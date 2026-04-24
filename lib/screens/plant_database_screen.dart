import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../services/plant_database_service.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

class PlantDatabaseScreen extends StatefulWidget {
  const PlantDatabaseScreen({super.key});
  @override
  State<PlantDatabaseScreen> createState() => _PlantDatabaseScreenState();
}

class _PlantDatabaseScreenState extends State<PlantDatabaseScreen> {
  String _query = '';
  PlantCategory? _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Växtdatabas')),
      body: Consumer<PlantDatabaseService>(
        builder: (ctx, db, _) {
          var list = db.searchByName(_query);
          if (_filter != null) {
            list = list.where((p) => p.kategori == _filter).toList();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Sök växt…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryChip(null, 'Alla'),
                    ...PlantCategory.values.map(
                      (c) => _categoryChip(c, '${c.emoji} ${c.label}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('Inga växter matchar'))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, i) => PlantCard(
                          plant: list[i],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plant: list[i]),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _categoryChip(PlantCategory? c, String label) {
    final selected = _filter == c;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = c),
      ),
    );
  }
}
