/// A generic gardener's chore that recurs every year for a given month
/// — independent of which plants you grow. Loaded once from
/// `assets/data/monthly_chores.json` by [MonthlyChoresService] and
/// surfaced on the home screen via [UpcomingCareCard].
///
/// Distinct from [CareTask] which is plant-specific. A user with no
/// plants in the garden still benefits from "rensa rabatter i april"
/// or "sätt vårblommande lökar i september".
class MonthlyChore {
  final String id;
  final int month;
  final String title;
  final String description;
  final String emoji;

  /// Optional plant-id filter. When present, the chore only applies if
  /// the user actually has at least one of these plants in their active
  /// garden — prevents "Gallra äpple och plommon" from showing up for
  /// someone who doesn't grow fruit trees. When null/empty, the chore
  /// is universal (e.g. "Beställ frön", "Rensa rabatter").
  final List<String> appliesToPlants;

  /// Optional plant-category filter. Same semantics as [appliesToPlants]
  /// but at a broader granularity — "applies to anyone with berries"
  /// rather than naming each species.
  final List<String> appliesToCategories;

  const MonthlyChore({
    required this.id,
    required this.month,
    required this.title,
    required this.description,
    required this.emoji,
    this.appliesToPlants = const [],
    this.appliesToCategories = const [],
  });

  factory MonthlyChore.fromJson(Map<String, dynamic> j) => MonthlyChore(
        id: j['id'] as String,
        month: j['manad'] as int,
        title: j['titel'] as String,
        description: j['beskrivning'] as String,
        emoji: j['emoji'] as String? ?? '🌿',
        appliesToPlants:
            List<String>.from(j['applies_to_plants'] as List? ?? const []),
        appliesToCategories: List<String>.from(
            j['applies_to_categories'] as List? ?? const []),
      );

  /// Whether this chore is universal (applies to everyone). False means
  /// caller should check user's garden against the filter lists.
  bool get isUniversal =>
      appliesToPlants.isEmpty && appliesToCategories.isEmpty;
}
