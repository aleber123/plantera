import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Custom square cropper. The user pans/zooms the picked photo inside a
/// fixed square viewport — only what's inside the viewport gets saved.
/// No external cropper dependency: we render the box via
/// `RepaintBoundary.toImage` and write the bytes to app docs.
///
/// Pops with the saved [File] on success, or null when the user cancels.
class CircleCropScreen extends StatefulWidget {
  final File source;
  const CircleCropScreen({super.key, required this.source});

  @override
  State<CircleCropScreen> createState() => _CircleCropScreenState();
}

class _CircleCropScreenState extends State<CircleCropScreen> {
  final GlobalKey _captureKey = GlobalKey();
  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _captureKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) throw StateError('Kunde inte koda PNG');
      final bytes = byteData.buffer.asUint8List();

      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'garden_photos'));
      if (!dir.existsSync()) dir.createSync(recursive: true);
      final ts = DateTime.now().millisecondsSinceEpoch;
      // Write to a temp file first, then atomic rename. If disk fills
      // up mid-write we don't leave a half-written file at the final
      // path that downstream code would treat as the user's hero.
      final tmp = File(p.join(dir.path, 'hero_$ts.png.tmp'));
      final dest = File(p.join(dir.path, 'hero_$ts.png'));
      await tmp.writeAsBytes(bytes, flush: true);
      await tmp.rename(dest.path);

      if (!mounted) return;
      Navigator.of(context).pop(dest);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kunde inte spara: $e')),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cropSize = width * 0.85;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Beskär bilden'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text(
              'Klar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(cropSize / 2),
              child: SizedBox(
                width: cropSize,
                height: cropSize,
                child: RepaintBoundary(
                  key: _captureKey,
                  child: ColoredBox(
                    color: Colors.white,
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 5,
                      clipBehavior: Clip.none,
                      child: Image.file(
                        widget.source,
                        fit: BoxFit.cover,
                        width: cropSize,
                        height: cropSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nyp för att zooma · dra för att placera',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            if (_saving) ...[
              const SizedBox(height: 16),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
