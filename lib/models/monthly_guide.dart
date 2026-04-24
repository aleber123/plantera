class GuideSection {
  final String title;
  final String emoji;
  final String intro;
  final List<String> bullets;
  final String? tip;
  final String? affiliateBundle;

  const GuideSection({
    required this.title,
    required this.emoji,
    required this.intro,
    required this.bullets,
    this.tip,
    this.affiliateBundle,
  });
}

class MonthlyGuide {
  final int month;
  final String headline;
  final String intro;
  final List<GuideSection> sections;
  final List<String> chores;

  const MonthlyGuide({
    required this.month,
    required this.headline,
    required this.intro,
    required this.sections,
    this.chores = const [],
  });
}
