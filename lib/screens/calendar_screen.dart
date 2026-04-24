import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plant.dart';
import '../services/plant_database_service.dart';
import '../services/zone_service.dart';
import '../utils/constants.dart';
import '../widgets/plant_card.dart';
import 'monthly_guide_screen.dart';
import 'plant_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final zone = context.watch<ZoneService>();
    final db = context.watch<PlantDatabaseService>();
    final day = _selected ?? _focused;
    final month = day.month;

    List<Plant> tasks = [
      ...db.forsaIMonth(month, zone.zone),
      ...db.direktsaIMonth(month, zone.zone),
      ...db.utplanteringIMonth(month, zone.zone),
      ...db.skordIMonth(month, zone.zone),
    ];
    tasks = tasks.toSet().toList()
      ..sort((a, b) => a.namnSv.compareTo(b.namnSv));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planteringskalender'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories),
            tooltip: 'Månadens guide',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MonthlyGuideScreen(initialMonth: month),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focused,
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            selectedDayPredicate: (d) => isSameDay(_selected, d),
            locale: 'sv_SE',
            onDaySelected: (sel, foc) =>
                setState(() {
                  _selected = sel;
                  _focused = foc;
                }),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Månad'},
            headerStyle: const HeaderStyle(formatButtonVisible: false),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${AppConstants.monthNamesSv[month]} – zon ${zone.zone}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('Inga planteringar denna månad'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, i) => PlantCard(
                      plant: tasks[i],
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              PlantDetailScreen(plant: tasks[i]),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
