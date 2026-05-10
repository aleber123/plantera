import 'dart:io';

import 'package:flutter/material.dart';

/// Circular avatar showing either the user's custom hero photo for a
/// garden plant, or the species emoji as a friendly fallback. Used in
/// MyGardenScreen, plant detail header, and anywhere we want a single
/// visual hook for "this plant".
class PlantHeroAvatar extends StatelessWidget {
  final String? heroPhotoPath;
  final String fallbackEmoji;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const PlantHeroAvatar({
    super.key,
    required this.heroPhotoPath,
    required this.fallbackEmoji,
    required this.size,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    // Skip the upfront File.existsSync — it's a synchronous I/O call
    // that fires every frame for every list item. Image.file's
    // errorBuilder already gives us the same fallback when the file
    // is missing, without the per-frame stat.
    final path = heroPhotoPath;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.green.shade50,
        border: Border.all(
          color: borderColor ?? Colors.green.shade200,
          width: borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: path == null
          ? _emoji()
          : Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _emoji(),
            ),
    );
  }

  Widget _emoji() => Center(
        child: Text(
          fallbackEmoji,
          style: TextStyle(fontSize: size * 0.55),
        ),
      );
}
