enum InsightUrgency { high, medium, low }

class DailyInsight {
  final String emoji;
  final String title;
  final String body;
  final InsightUrgency urgency;
  final String? gardenPlantId;

  const DailyInsight({
    required this.emoji,
    required this.title,
    required this.body,
    required this.urgency,
    this.gardenPlantId,
  });
}
