import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'garden_service.dart';
import 'harvest_service.dart';
import 'season_planner_service.dart';

/// Pure data export/import — no native iCloud or CloudKit. The user
/// gets a JSON file they can save anywhere (iCloud Drive, email,
/// Dropbox) via the system share sheet, and re-import on a new phone.
///
/// Why JSON instead of a sqlite copy: portable, human-readable, and we
/// only ship a handful of tables. Migration of a dumped DB is fragile;
/// a versioned JSON schema is easier to keep stable across app
/// upgrades.
///
/// To enable automatic iCloud-Drive sync of the *Documents* folder
/// where this app writes, the iOS host project also needs the iCloud
/// capability turned on in Xcode + a UbiquityContainer entitlement.
/// That's a project-level config the user toggles once, not a
/// code-level concern handled here.
class BackupService {
  static const _schemaVersion = 1;
  static const _filename = 'plantera_backup.json';

  /// Build a portable JSON snapshot of the user's data and hand it to
  /// the system share sheet. Returns the saved file path on success
  /// (mostly useful for tests; the user just sees the share UI).
  Future<String> exportToShare({
    required GardenService garden,
    required HarvestService harvest,
    required SeasonPlannerService season,
  }) async {
    final json = _buildSnapshot(
      garden: garden,
      harvest: harvest,
      season: season,
    );
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_filename');
    await file.writeAsString(jsonEncode(json), flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Plantera-säkerhetskopia',
      text:
          'Säkerhetskopia av din trädgård. Spara på iCloud Drive eller skicka till dig själv så att du har den om du byter telefon.',
    );
    return file.path;
  }

  // Import is intentionally not exposed yet. The right UX is to either
  // (a) auto-load the file from a known iCloud Drive folder when the
  // user reinstalls the app, or (b) accept a file via the iOS Files
  // app's "Open in Plantera". Both need additional iOS host setup the
  // export side doesn't. For now: export-only. The JSON schema below
  // is stable enough that import can be wired up later without
  // breaking existing backups.

  Map<String, dynamic> _buildSnapshot({
    required GardenService garden,
    required HarvestService harvest,
    required SeasonPlannerService season,
  }) {
    // Export *all* gardens, not just the active one — otherwise a
    // multi-garden user silently loses every other garden's plants and
    // wishlist on restore. allPlants/allItems span all gardens, and the
    // gardens table itself carries the name/lat/lon/zone we'd lose too.
    return {
      'schema': _schemaVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'gardens': garden.gardens.map((g) => g.toMap()).toList(),
      'plants': garden.allPlants.map((g) => g.toMap()).toList(),
      'harvests': harvest.entries.map((e) => e.toMap()).toList(),
      'wishlist': season.allItems.map((w) => w.toMap()).toList(),
    };
  }

  /// Last-resort recovery: write the snapshot to a known location
  /// in the Documents folder *without* opening the share sheet. Useful
  /// for an automatic background save schedule (not yet wired up).
  Future<File> writeSilent({
    required GardenService garden,
    required HarvestService harvest,
    required SeasonPlannerService season,
  }) async {
    final json = _buildSnapshot(
      garden: garden,
      harvest: harvest,
      season: season,
    );
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_filename');
    await file.writeAsString(jsonEncode(json), flush: true);
    debugPrint('Backup written to ${file.path}');
    return file;
  }
}
