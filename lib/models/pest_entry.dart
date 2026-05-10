/// Static reference entry for a pest, disease, or other plant trouble.
/// Loaded from `assets/data/pests.json` and surfaced via
/// [PestLibraryScreen] (and from PlantDetailScreen for plants whose
/// `skadedjur` list mentions a name in this library).
class PestEntry {
  final String id;
  final String name;
  final String emoji;
  /// 'skadedjur' | 'sjukdom' | 'skada' — drives the colored badge so
  /// the user can scan-distinguish "djur" from "svamp" at a glance.
  final String type;
  final String symptoms;
  /// Plant ids or human-readable names that get hit. Used both for
  /// search and to show "påverkar dina växter"-tags.
  final List<String> affects;
  final String mildAction;
  final String strongAction;
  final String prevention;

  const PestEntry({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    required this.symptoms,
    required this.affects,
    required this.mildAction,
    required this.strongAction,
    required this.prevention,
  });

  factory PestEntry.fromJson(Map<String, dynamic> j) => PestEntry(
        id: j['id'] as String,
        name: j['namn'] as String,
        emoji: j['emoji'] as String? ?? '🐛',
        type: j['typ'] as String,
        symptoms: j['symptom'] as String,
        affects: (j['drabbar'] as List? ?? const [])
            .map((e) => e as String)
            .toList(),
        mildAction: j['atgard_milt'] as String? ?? '',
        strongAction: j['atgard_starkt'] as String? ?? '',
        prevention: j['forebygg'] as String? ?? '',
      );
}
