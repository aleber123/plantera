/// Botanical families relevant to crop rotation in Swedish kitchen
/// gardens. Two plants in the same family share pests, diseases, and
/// nutrient demands — so growing them in the same spot year after year
/// drains the soil and lets pathogens build up.
///
/// We don't bother with every family that exists, only the ones a
/// gardener actually rotates between. Anything we don't classify
/// returns `PlantFamily.other` and is shown as "Övrigt" in rotation
/// history rather than being silently dropped.
enum PlantFamily {
  korsblommiga, // Brassicaceae — cabbages, root veg related
  nattskuggor, // Solanaceae — tomato, potato, pepper
  baljvaxter, // Fabaceae — beans, peas (nitrogen fixers)
  lokvaxter, // Alliaceae — onion, garlic, leek
  flockblommiga, // Apiaceae — carrots, parsnip, dill, parsley
  pumpavaxter, // Cucurbitaceae — cucumber, squash, pumpkin
  korgblommiga, // Asteraceae — lettuce, sunflower, artichoke
  mallvaxter, // Amaranthaceae — beet, spinach, chard
  grasvaxter, // Poaceae — corn (in vegetable rotation)
  rosvaxter, // Rosaceae — strawberry, raspberry, apple, pear, plum
  ribesvaxter, // Grossulariaceae — currant, gooseberry
  blueberryvaxter, // Ericaceae — blueberry
  other;

  String get label => switch (this) {
        PlantFamily.korsblommiga => 'Korsblommiga',
        PlantFamily.nattskuggor => 'Nattskuggor',
        PlantFamily.baljvaxter => 'Baljväxter',
        PlantFamily.lokvaxter => 'Lökväxter',
        PlantFamily.flockblommiga => 'Flockblommiga',
        PlantFamily.pumpavaxter => 'Pumpaväxter',
        PlantFamily.korgblommiga => 'Korgblommiga',
        PlantFamily.mallvaxter => 'Mållväxter',
        PlantFamily.grasvaxter => 'Gräsväxter',
        PlantFamily.rosvaxter => 'Rosväxter',
        PlantFamily.ribesvaxter => 'Ribes-släktet',
        PlantFamily.blueberryvaxter => 'Ljungväxter',
        PlantFamily.other => 'Övrigt',
      };

  /// Soft tint for badges. Should pair with white text on the accent.
  int get accentArgb => switch (this) {
        PlantFamily.korsblommiga => 0xFF6A1B9A,
        PlantFamily.nattskuggor => 0xFFC62828,
        PlantFamily.baljvaxter => 0xFF2E7D32,
        PlantFamily.lokvaxter => 0xFF8E24AA,
        PlantFamily.flockblommiga => 0xFFEF6C00,
        PlantFamily.pumpavaxter => 0xFFF9A825,
        PlantFamily.korgblommiga => 0xFF558B2F,
        PlantFamily.mallvaxter => 0xFF6D4C41,
        PlantFamily.grasvaxter => 0xFFAFB42B,
        PlantFamily.rosvaxter => 0xFFD81B60,
        PlantFamily.ribesvaxter => 0xFF5D4037,
        PlantFamily.blueberryvaxter => 0xFF3949AB,
        PlantFamily.other => 0xFF6D6D6D,
      };

  /// One-line gardening rule for what's good (or bad) to follow this
  /// family with. Surfaced on the rotation panel for context.
  String get rotationTip => switch (this) {
        PlantFamily.korsblommiga =>
          'Vänta minst 3 år innan du odlar samma familj här igen – klumprotsjuka kan bli kvar i jorden.',
        PlantFamily.nattskuggor =>
          'Vänta 3-4 år. Bladmögel och tomatröta överlever i jord.',
        PlantFamily.baljvaxter =>
          'Lämnar kväverik jord – perfekt för korsblommiga eller pumpaväxter nästa år.',
        PlantFamily.lokvaxter =>
          'Vänta 2 år innan ny lök på samma plats.',
        PlantFamily.flockblommiga =>
          'Vänta 2 år. Morötternas sjukdomar lever kvar i jorden.',
        PlantFamily.pumpavaxter =>
          'Krävande på näring. Gödsla rikligt nästa år, eller följ med baljväxter som bygger upp.',
        PlantFamily.korgblommiga =>
          'Lättroterad – kan följas av nästan vad som helst.',
        PlantFamily.mallvaxter =>
          'Vänta 2 år. Bra föregångare till lökväxter.',
        PlantFamily.grasvaxter =>
          'Tar mycket kväve. Följ med baljväxter eller efterföljande gödning.',
        _ => 'Långt liv på samma plats – rotation gäller mest fleråriga växter när du föryngrar bädden.',
      };

  /// Resolve a [PlantFamily] from a plant id. Returns `other` for ids
  /// we haven't classified — keeps the rotation panel inclusive
  /// without forcing every plant in the database to be tagged.
  static PlantFamily fromPlantId(String id) {
    return _byId[id] ?? PlantFamily.other;
  }
}

const Map<String, PlantFamily> _byId = {
  // Korsblommiga
  'vitkal': PlantFamily.korsblommiga,
  'gronkal': PlantFamily.korsblommiga,
  'brysselkal': PlantFamily.korsblommiga,
  'broccoli': PlantFamily.korsblommiga,
  'blomkal': PlantFamily.korsblommiga,
  'pak_choi': PlantFamily.korsblommiga,
  'radisa': PlantFamily.korsblommiga,
  'ruccola': PlantFamily.korsblommiga,
  'mangold': PlantFamily.mallvaxter, // looks similar but is mall

  // Nattskuggor
  'tomat': PlantFamily.nattskuggor,
  'potatis': PlantFamily.nattskuggor,
  'paprika': PlantFamily.nattskuggor,
  'chili': PlantFamily.nattskuggor,
  'aubergine': PlantFamily.nattskuggor,
  'physalis': PlantFamily.nattskuggor,

  // Baljväxter
  'grusbonor': PlantFamily.baljvaxter,
  'sockerart': PlantFamily.baljvaxter,
  'vaxbona': PlantFamily.baljvaxter,

  // Lökväxter
  'lok': PlantFamily.lokvaxter,
  'vitlok': PlantFamily.lokvaxter,
  'purjolok': PlantFamily.lokvaxter,
  'schalottenlok': PlantFamily.lokvaxter,
  'gräslök': PlantFamily.lokvaxter,

  // Flockblommiga
  'morot': PlantFamily.flockblommiga,
  'palsternacka': PlantFamily.flockblommiga,
  'fankal': PlantFamily.flockblommiga,
  'svartrot': PlantFamily.korgblommiga,
  'dill': PlantFamily.flockblommiga,
  'persilja': PlantFamily.flockblommiga,
  'koriander': PlantFamily.flockblommiga,
  'libsticka': PlantFamily.flockblommiga,

  // Pumpaväxter
  'gurka': PlantFamily.pumpavaxter,
  'squash': PlantFamily.pumpavaxter,
  'zucchini': PlantFamily.pumpavaxter,
  'pumpa': PlantFamily.pumpavaxter,

  // Korgblommiga
  'isbergssallad': PlantFamily.korgblommiga,
  'plocksallad': PlantFamily.korgblommiga,
  'solros': PlantFamily.korgblommiga,
  'kronartskocka': PlantFamily.korgblommiga,
  'kal_fransk_kronartskocka': PlantFamily.korgblommiga,
  'tagetes': PlantFamily.korgblommiga,
  'ringblomma': PlantFamily.korgblommiga,
  'prastkrage': PlantFamily.korgblommiga,

  // Mållväxter
  'rodbeta': PlantFamily.mallvaxter,
  'spenat': PlantFamily.mallvaxter,
  'faltsallat': PlantFamily.mallvaxter,

  // Gräsväxter
  'majs': PlantFamily.grasvaxter,

  // Rosväxter
  'jordgubbe': PlantFamily.rosvaxter,
  'smultron': PlantFamily.rosvaxter,
  'hallon': PlantFamily.rosvaxter,
  'bjornbar': PlantFamily.rosvaxter,
  'aple': PlantFamily.rosvaxter,
  'päron': PlantFamily.rosvaxter,
  'plommon': PlantFamily.rosvaxter,
  'korsbar': PlantFamily.rosvaxter,
  'lagroskar': PlantFamily.rosvaxter,
  'lagerhortensia': PlantFamily.rosvaxter,

  // Ribesväxter
  'svarta_vinbar': PlantFamily.ribesvaxter,
  'roda_vinbar': PlantFamily.ribesvaxter,
  'krusbar': PlantFamily.ribesvaxter,

  // Ljungväxter
  'blabar': PlantFamily.blueberryvaxter,
};
