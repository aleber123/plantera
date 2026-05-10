import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/badge_service.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'my_garden_screen.dart';
import 'plant_database_screen.dart';
import 'settings_screen.dart';
import 'todo_screen.dart';

/// Controller surface for switching tabs from any descendant. Lets
/// home-card buttons hop to "Mina växter" (tab 3) or push the plant
/// database without needing GlobalKeys threaded through the tree.
abstract class MainShellController {
  void goToTab(int index);

  /// Plant database used to be its own tab; now it's accessed via
  /// CTAs ("Bläddra växter") that push it modally from any screen.
  /// This indirection means callers don't need to know which file the
  /// database screen lives in.
  void openPlantDatabase(BuildContext context);

  static MainShellController? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainShellState>();
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with WidgetsBindingObserver
    implements MainShellController {
  // Att göra is primary because it's where action lives. Hem becomes a
  // calmer "context" surface (väder, säsongsplanerare). Mina växter
  // (was "Min trädgård") is the canonical garden view — no longer
  // duplicated by a "Min trädgård just nu"-card on Hem.
  int _index = 0;
  final _pages = const [
    TodoScreen(),
    HomeScreen(),
    CalendarScreen(),
    MyGardenScreen(),
    SettingsScreen(),
  ];

  @override
  void goToTab(int index) {
    if (index < 0 || index >= _pages.length) return;
    if (_index == index) return;
    setState(() => _index = index);
  }

  @override
  void openPlantDatabase(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PlantDatabaseScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BadgeService.clear();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BadgeService.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Builder(builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.checklist_rounded),
                label: l10n.tabTodo),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: l10n.tabHome),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
                label: l10n.tabCalendar),
            BottomNavigationBarItem(
                icon: const Icon(Icons.yard), label: l10n.tabMyGarden),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings), label: l10n.tabSettings),
          ],
        );
      }),
    );
  }
}
