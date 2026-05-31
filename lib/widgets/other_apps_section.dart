import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Other apps by Alexander" cross-promotion widget. Drop into Settings
/// of every app — the [currentBundleId] is filtered out so users don't
/// see the app they're already in.
///
/// Same file is shipped into all 10+ apps; only the bundle id and theme
/// colors change. Keep the [_apps] list in sync across copies — manual,
/// but list churns rarely.
///
/// Heading + taglines are localized via the maps below; app names stay
/// in their original (Swedish) form since they're brand names. Apple
/// auto-redirects the /se/ App Store URLs to the user's regional
/// storefront, so links work for any user worldwide.
class OtherAppsSection extends StatelessWidget {
  final String currentBundleId;
  final String? heading;
  final Color? accentColor;

  const OtherAppsSection({
    super.key,
    required this.currentBundleId,
    this.heading,
    this.accentColor,
  });

  /// Localized "More apps by Alexander" heading per language.
  static const Map<String, String> _headings = {
    'sv': 'FLER APPAR AV ALEXANDER',
    'en': 'MORE APPS BY ALEXANDER',
    'nb': 'FLERE APPER AV ALEXANDER',
    'no': 'FLERE APPER AV ALEXANDER',
    'da': 'FLERE APPS AF ALEXANDER',
    'fi': 'LISÄÄ ALEXANDERIN SOVELLUKSIA',
    'de': 'WEITERE APPS VON ALEXANDER',
    'fr': "PLUS D'APPS PAR ALEXANDER",
    'es': 'MÁS APPS DE ALEXANDER',
    'it': 'ALTRE APP DI ALEXANDER',
    'nl': 'MEER APPS VAN ALEXANDER',
    'pt': 'MAIS APPS DO ALEXANDER',
    'pl': 'WIĘCEJ APLIKACJI ALEXANDRA',
    'el': 'ΠΕΡΙΣΣΟΤΕΡΕΣ ΕΦΑΡΜΟΓΕΣ',
    'is': 'FLEIRI ÖPP EFTIR ALEXANDER',
  };

  static const List<_AppEntry> _apps = [
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.birthdayreminder',
      name: 'Födelsedagar',
      emoji: '🎂',
      url: 'https://apps.apple.com/se/app/f%C3%B6delsedagar/id6758899294',
      taglines: {
        'sv': 'Glöm aldrig en födelsedag igen',
        'en': 'Never forget a birthday again',
        'nb': 'Glem aldri en bursdag igjen',
        'da': 'Glem aldrig en fødselsdag igen',
        'fi': 'Älä koskaan unohda syntymäpäivää',
        'de': 'Vergiss nie wieder einen Geburtstag',
        'fr': "N'oubliez plus jamais un anniversaire",
        'es': 'Nunca olvides un cumpleaños',
        'it': 'Non dimenticare mai un compleanno',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.surdeg',
      name: 'Surdeg',
      emoji: '🍞',
      url: 'https://apps.apple.com/se/app/surdeg/id6766092580',
      taglines: {
        'sv': 'Mata, baka, njut',
        'en': 'Feed, bake, enjoy',
        'nb': 'Mat, bak, nyt',
        'da': 'Fodr, bag, nyd',
        'fi': 'Ruoki, leivo, nauti',
        'de': 'Füttern, backen, genießen',
        'fr': 'Nourrir, cuire, savourer',
        'es': 'Alimenta, hornea, disfruta',
        'it': 'Nutri, cuoci, goditi',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.plantera',
      name: 'Plantera',
      emoji: '🌱',
      url: 'https://apps.apple.com/se/app/plantera/id6763648199',
      taglines: {
        'sv': 'Trädgårdsapp med frostvarningar',
        'en': 'Garden app with frost warnings',
        'nb': 'Hageapp med frostvarsler',
        'da': 'Haveapp med frostadvarsler',
        'fi': 'Puutarhasovellus pakkasvaroituksin',
        'de': 'Garten-App mit Frostwarnungen',
        'fr': 'App jardin avec alertes gel',
        'es': 'App de jardín con alertas de heladas',
        'it': 'App giardino con avvisi di gelo',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.vabapp',
      name: 'VAB-koll',
      emoji: '👶',
      url: 'https://apps.apple.com/se/app/vab-koll/id6763138809',
      // VAB is a Sweden-specific tax/insurance term. Keep tagline in
      // Swedish across all locales — non-Swedish users won't have a
      // use case anyway, and the App Store listing is sv-only.
      taglines: {
        'sv': 'Håll koll på dina VAB-dagar',
        'en': 'Track your Swedish parental care days',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.tidrapportera',
      name: 'Tidrapportera',
      emoji: '⏱️',
      url: 'https://apps.apple.com/se/app/tidrapportera/id6762660992',
      taglines: {
        'sv': 'Snabb tidrapport för konsulter',
        'en': 'Fast time tracking for consultants',
        'nb': 'Rask timeregistrering for konsulenter',
        'da': 'Hurtig tidsregistrering for konsulenter',
        'fi': 'Nopea ajanseuranta konsulteille',
        'de': 'Schnelle Zeiterfassung für Berater',
        'fr': 'Suivi du temps rapide pour consultants',
        'es': 'Registro de tiempo rápido para consultores',
        'it': 'Tracciamento tempo veloce per consulenti',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.renoveraapp',
      name: 'Renovera',
      emoji: '🔨',
      url: 'https://apps.apple.com/se/app/renovera/id6763392279',
      taglines: {
        'sv': '31 kalkylatorer för hemrenovering',
        'en': '31 home renovation calculators',
        'nb': '31 kalkulatorer for hjemmerenovering',
        'da': '31 beregnere til hjemmerenovering',
        'fi': '31 laskuria kotiremonttiin',
        'de': '31 Heimrenovierungs-Rechner',
        'fr': '31 calculatrices de rénovation',
        'es': '31 calculadoras de renovación',
        'it': '31 calcolatori per ristrutturazione',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.andas',
      name: 'Andas',
      emoji: '🌬️',
      url: 'https://apps.apple.com/se/app/andas/id6766963076',
      taglines: {
        'sv': 'Guidad andning — lugn på 4 min',
        'en': 'Guided breathing — calm in 4 min',
        'nb': 'Guidet pust — ro på 4 min',
        'da': 'Guidet vejrtrækning — ro på 4 min',
        'fi': 'Ohjattu hengitys — rauha 4 minuutissa',
        'de': 'Geführte Atmung — ruhig in 4 Min',
        'fr': 'Respiration guidée — calme en 4 min',
        'es': 'Respiración guiada — calma en 4 min',
        'it': 'Respirazione guidata — calma in 4 min',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.somnkollapp',
      name: 'Sömnkoll',
      emoji: '😴',
      url: 'https://apps.apple.com/se/app/s%C3%B6mnkoll/id6763792588',
      taglines: {
        'sv': 'Trackar din sömn utan klocka',
        'en': 'Track sleep without a watch',
        'nb': 'Spor søvnen din uten klokke',
        'da': 'Spor din søvn uden ur',
        'fi': 'Seuraa unta ilman kelloa',
        'de': 'Schlaf tracken ohne Uhr',
        'fr': 'Suivez votre sommeil sans montre',
        'es': 'Rastrea tu sueño sin reloj',
        'it': 'Traccia il sonno senza orologio',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.ritaapp',
      name: 'Rita & Färglägg',
      emoji: '🎨',
      url: 'https://apps.apple.com/se/app/rita-f%C3%A4rgl%C3%A4gg/id6763882162',
      // Rita's App Store listing is sv-only per ASC localization
      // (we verified via iTunes API). Keep tagline in sv for everyone.
      taglines: {
        'sv': 'Färgläggning för barn 3–8 år',
        'en': 'Coloring for kids 3–8',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.slutasnusa',
      name: 'Snusfri Resa',
      emoji: '🚭',
      url: 'https://apps.apple.com/se/app/snusfri-resa/id6766103729',
      taglines: {
        'sv': 'Timmar och kronor sparade',
        'en': 'Hours and money saved',
        'nb': 'Timer og kroner spart',
        'da': 'Timer og kroner sparet',
        'fi': 'Tunnit ja eurot säästetyt',
        'de': 'Stunden und Geld gespart',
        'fr': 'Heures et argent économisés',
        'es': 'Horas y dinero ahorrados',
        'it': 'Ore e denaro risparmiati',
      },
    ),
    _AppEntry(
      bundleId: 'com.alexanderbergqvist.fokus',
      name: 'Pomatic',
      emoji: '🍅',
      url: 'https://apps.apple.com/se/app/pomatic/id6770679116',
      taglines: {
        'sv': 'Pomodoro-timer för djupfokus',
        'en': 'Pomodoro timer for deep focus',
        'nb': 'Pomodoro-timer for dyp fokus',
        'da': 'Pomodoro-timer til dyb fokus',
        'fi': 'Pomodoro-ajastin syvään keskittymiseen',
        'de': 'Pomodoro-Timer für tiefen Fokus',
        'fr': 'Minuteur Pomodoro pour focus profond',
        'es': 'Temporizador Pomodoro para concentración',
        'it': 'Timer Pomodoro per focus profondo',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible =
        _apps.where((a) => a.bundleId != currentBundleId).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    final accent = accentColor ?? Theme.of(context).colorScheme.primary;
    final lang = Localizations.localeOf(context).languageCode;
    final resolvedHeading =
        heading ?? _headings[lang] ?? _headings['sv']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            resolvedHeading,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < visible.length; i++) ...[
                _AppRow(entry: visible[i], accent: accent, lang: lang),
                if (i < visible.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AppEntry {
  final String bundleId;
  final String name;
  final String emoji;
  final String url;
  final Map<String, String> taglines;
  const _AppEntry({
    required this.bundleId,
    required this.name,
    required this.emoji,
    required this.url,
    required this.taglines,
  });

  /// Best-fit tagline for the given UI language. Falls back to English,
  /// then Swedish (which every app has).
  String tagline(String lang) =>
      taglines[lang] ?? taglines['en'] ?? taglines['sv']!;
}

class _AppRow extends StatelessWidget {
  final _AppEntry entry;
  final Color accent;
  final String lang;
  const _AppRow({
    required this.entry,
    required this.accent,
    required this.lang,
  });

  Future<void> _open() async {
    final uri = Uri.parse(entry.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(entry.emoji, style: const TextStyle(fontSize: 22)),
      ),
      title: Text(
        entry.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(entry.tagline(lang)),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: _open,
    );
  }
}
