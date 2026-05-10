import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/garden_plant.dart';
import '../services/garden_service.dart';

/// Horizontal photo strip for one garden plant. Photos are stored under
/// the app's documents directory (no network) and tracked via the
/// existing `garden_notes` table by reusing its `photo_path` column.
class GardenPhotoTimeline extends StatefulWidget {
  final String gardenPlantId;
  const GardenPhotoTimeline({super.key, required this.gardenPlantId});

  @override
  State<GardenPhotoTimeline> createState() => _GardenPhotoTimelineState();
}

class _GardenPhotoTimelineState extends State<GardenPhotoTimeline> {
  final ImagePicker _picker = ImagePicker();
  bool _picking = false;
  // Prevent simultaneous deletes from racing — if user double-taps the
  // long-press menu the second call would have orphaned the DB row.
  final Set<String> _deletingNoteIds = {};

  Future<void> _addPhoto(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;

      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'garden_photos'));
      if (!dir.existsSync()) dir.createSync(recursive: true);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(picked.path).isEmpty ? '.jpg' : p.extension(picked.path);
      final dest = p.join(dir.path, '${widget.gardenPlantId}_$ts$ext');
      await File(picked.path).copy(dest);

      if (!mounted) return;
      await context
          .read<GardenService>()
          .addNote(widget.gardenPlantId, '', photoPath: dest);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kunde inte spara foto: $e')),
      );
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _showPickerSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ta foto'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Välj från bibliotek'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) await _addPhoto(source);
  }

  Future<void> _confirmDelete(GardenNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ta bort foto?'),
        content: const Text('Bilden raderas från enheten.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Ta bort',
                style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    if (_deletingNoteIds.contains(note.id)) return;
    _deletingNoteIds.add(note.id);
    try {
      if (note.photoPath != null) {
        try {
          final f = File(note.photoPath!);
          if (f.existsSync()) await f.delete();
        } catch (_) {/* file already gone — proceed with DB cleanup */}
      }
      if (!mounted) return;
      await context.read<GardenService>().deleteNote(note.id);
    } finally {
      _deletingNoteIds.remove(note.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GardenService>(
      builder: (ctx, garden, _) {
        final gp = garden.plants
            .where((g) => g.id == widget.gardenPlantId)
            .firstOrNull;
        final photos = (gp?.notes ?? const <GardenNote>[])
            .where((n) => n.photoPath != null)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '📸 Tidslinje',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _picking ? null : _showPickerSheet,
                  icon: _picking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_a_photo, size: 18),
                  label: const Text('Lägg till'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 120,
              child: photos.isEmpty
                  ? _emptyHint()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, i) =>
                          _photoTile(photos[i], photos.length, i),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _emptyHint() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E2D2)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Text(
        'Inga foton ännu — börja dokumentera tillväxten',
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _photoTile(GardenNote note, int total, int index) {
    final file = File(note.photoPath!);
    return GestureDetector(
      onLongPress: () => _confirmDelete(note),
      onTap: () => _viewFullScreen(file, note.date, total, index),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E2D2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image,
                    color: Colors.black26),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 4),
                child: Text(
                  DateFormat('d MMM').format(note.date),
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewFullScreen(File file, DateTime date, int total, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(
              '${DateFormat('d MMM y').format(date)} • ${index + 1}/$total',
            ),
          ),
          body: Center(child: InteractiveViewer(child: Image.file(file))),
        ),
      ),
    );
  }
}
