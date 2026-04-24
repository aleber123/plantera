import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'my_garden_screen.dart';
import 'plant_database_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pages = const [
    HomeScreen(),
    CalendarScreen(),
    PlantDatabaseScreen(),
    MyGardenScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hem'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Kalender'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Växter'),
          BottomNavigationBarItem(
              icon: Icon(Icons.yard), label: 'Min trädgård'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Inställningar'),
        ],
      ),
    );
  }
}
