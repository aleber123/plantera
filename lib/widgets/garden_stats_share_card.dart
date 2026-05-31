import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Renders an Instagram-square (1080×1080) summary image of the user's
/// garden year and triggers the OS share sheet. The card is rendered
/// off-screen via an OverlayEntry — never visible in the app itself,
/// only as a saved PNG handed to share_plus.
///
/// Design intent: shareable enough that gardeners post it to Instagram
/// / Facebook unprompted, driving organic growth back to Plantera.
class GardenStatsShareCard {
  /// Pixel dimensions for the rendered image. Instagram square is the
  /// safest cross-platform shareable aspect — also great for Facebook,
  /// LinkedIn and iMessage previews.
  static const double _imageSize = 1080;

  static Future<void> shareYearSummary(
    BuildContext context, {
    required int year,
    required int totalPlants,
    required int speciesCount,
    required int harvested,
    required int estimatedSek,
    required List<({String name, String emoji, double sek})> topSpecies,
    required String shareText,
    Rect? sharePositionOrigin,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final pngBytes = await _renderCardToPng(
        context: context,
        year: year,
        totalPlants: totalPlants,
        speciesCount: speciesCount,
        harvested: harvested,
        estimatedSek: estimatedSek,
        topSpecies: topSpecies,
      );

      final dir = await getTemporaryDirectory();
      final file = File(p.join(
        dir.path,
        'plantera-$year-${DateTime.now().millisecondsSinceEpoch}.png',
      ));
      await file.writeAsBytes(pngBytes);

      // iOS share-sheet popover anchor. Required on iPad and on iOS 16+
      // phones via share_plus 11+; passing an empty Rect crashes with
      // "{{0,0},{0,0}} must be non-zero". When the caller doesn't know
      // the source widget's frame, anchor at screen-bottom-center so the
      // sheet animates up from the natural share-button location.
      final origin = sharePositionOrigin ?? _fallbackOrigin(context);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: shareText,
        sharePositionOrigin: origin,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Kunde inte skapa delningsbild: $e')),
      );
    }
  }

  static Rect _fallbackOrigin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Rect.fromLTWH(size.width / 2 - 1, size.height - 80, 2, 2);
  }

  static Future<Uint8List> _renderCardToPng({
    required BuildContext context,
    required int year,
    required int totalPlants,
    required int speciesCount,
    required int harvested,
    required int estimatedSek,
    required List<({String name, String emoji, double sek})> topSpecies,
  }) async {
    // We render the card into an off-screen RepaintBoundary attached to
    // a transient OverlayEntry — the only reliable way to capture a
    // widget tree to image without forcing it into the visible layout.
    final repaintKey = GlobalKey();
    final completer = Completer<void>();

    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        // Position far off-screen so it's never visible. RepaintBoundary
        // still paints the full subtree because Flutter doesn't cull
        // out-of-bounds RepaintBoundary descendants.
        left: -10000,
        top: -10000,
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: repaintKey,
            child: _ShareCardContent(
              year: year,
              totalPlants: totalPlants,
              speciesCount: speciesCount,
              harvested: harvested,
              estimatedSek: estimatedSek,
              topSpecies: topSpecies,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(overlayEntry);

    // Allow two frame cycles so the subtree both lays out and paints
    // before we ask for the captured image. One frame is sometimes
    // enough but the second guards against text-shaping timing issues
    // when system fonts haven't been measured yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        completer.complete();
      });
    });
    await completer.future;

    try {
      final boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      // pixelRatio 1.0 — we already render at 1080×1080 logical units
      // so the output is 1080 physical pixels regardless of device DPI.
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } finally {
      overlayEntry.remove();
    }
  }
}

class _ShareCardContent extends StatelessWidget {
  final int year;
  final int totalPlants;
  final int speciesCount;
  final int harvested;
  final int estimatedSek;
  final List<({String name, String emoji, double sek})> topSpecies;
  const _ShareCardContent({
    required this.year,
    required this.totalPlants,
    required this.speciesCount,
    required this.harvested,
    required this.estimatedSek,
    required this.topSpecies,
  });

  @override
  Widget build(BuildContext context) {
    final hasHarvest = estimatedSek > 0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: GardenStatsShareCard._imageSize,
        height: GardenStatsShareCard._imageSize,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEFF6E5), Color(0xFFCDE0AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(72, 72, 72, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand row
            Row(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 56)),
                const SizedBox(width: 14),
                Text(
                  'Plantera',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D5016),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              'Min trädgård $year',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
                height: 1.05,
              ),
            ),
            const SizedBox(height: 24),
            // Hero number
            if (hasHarvest) ...[
              Text(
                '~$estimatedSek kr',
                style: const TextStyle(
                  fontSize: 132,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D5016),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'odlat värde',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5240),
                ),
              ),
            ] else ...[
              Text(
                '$totalPlants växter',
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D5016),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'i min trädgård',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5240),
                ),
              ),
            ],
            const Spacer(),
            // Stats row
            Row(
              children: [
                _StatBlock(value: '$totalPlants', label: 'växter'),
                const SizedBox(width: 28),
                _StatBlock(value: '$speciesCount', label: 'arter'),
                const SizedBox(width: 28),
                _StatBlock(value: '$harvested', label: 'skördade'),
              ],
            ),
            const SizedBox(height: 40),
            // Top species strip
            if (topSpecies.isNotEmpty)
              Wrap(
                spacing: 14,
                runSpacing: 12,
                children: [
                  for (final t in topSpecies.take(4))
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(t.emoji,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 10),
                          Text(
                            t.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 28),
            // Footer
            Row(
              children: [
                Text(
                  'plantera.app',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D5016).withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  '#odlasjälv',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D5016).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  const _StatBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1F2A1A),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5240),
          ),
        ),
      ],
    );
  }
}
