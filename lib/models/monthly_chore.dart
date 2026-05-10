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

  const MonthlyChore({
    required this.id,
    required this.month,
    required this.title,
    required this.description,
    required this.emoji,
  });

  factory MonthlyChore.fromJson(Map<String, dynamic> j) => MonthlyChore(
        id: j['id'] as String,
        month: j['manad'] as int,
        title: j['titel'] as String,
        description: j['beskrivning'] as String,
        emoji: j['emoji'] as String? ?? '🌿',
      );
}
