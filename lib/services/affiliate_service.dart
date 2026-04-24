import '../models/plant.dart';
import '../utils/constants.dart';

class AffiliateProduct {
  final String emoji;
  final String name;
  final String query;
  const AffiliateProduct(this.emoji, this.name, this.query);
}

class AffiliateService {
  /// Generic garden-starter kit (shown in onboarding / Settings).
  static const List<AffiliateProduct> starterKit = [
    AffiliateProduct('🪣', 'Skottkärra', 'skottkärra trädgård'),
    AffiliateProduct('🧤', 'Trädgårdshandskar', 'trädgårdshandskar'),
    AffiliateProduct('🪴', 'Spade & kratta', 'spade kratta trädgård'),
    AffiliateProduct('💧', 'Vattenkanna', 'vattenkanna trädgård'),
    AffiliateProduct('✂️', 'Sekatör', 'sekatör rosor'),
    AffiliateProduct('🪨', 'Planteringsjord', 'planteringsjord såjord'),
  ];

  /// Frost-warning recommended items.
  static const List<AffiliateProduct> frostProtection = [
    AffiliateProduct('❄️', 'Fiberduk / växtskydd', 'fiberduk frostskydd'),
    AffiliateProduct('🏠', 'Mini-växthus', 'odlingshus mini växthus'),
    AffiliateProduct('🌡️', 'Min/Max-termometer', 'min max termometer trädgård'),
    AffiliateProduct('🪴', 'Kruka med värmeskydd', 'frostfri kruka'),
  ];

  /// Items for indoor pre-sowing (förså).
  static const List<AffiliateProduct> forsaKit = [
    AffiliateProduct('📦', 'Odlingsbrätte', 'odlingsbrätte sådd'),
    AffiliateProduct('💡', 'Växtbelysning LED', 'växtbelysning led'),
    AffiliateProduct('🧪', 'Såjord', 'såjord torvjord'),
    AffiliateProduct('🏷️', 'Plantetiketter', 'plantetiketter'),
    AffiliateProduct('💦', 'Sprayflaska', 'sprayflaska vatten växt'),
  ];

  /// Category-specific tools and supplies.
  static const Map<PlantCategory, List<AffiliateProduct>> byCategory = {
    PlantCategory.gronsaker: [
      AffiliateProduct('📦', 'Odlingsbrätte', 'odlingsbrätte grönsaker'),
      AffiliateProduct('🪵', 'Odlingslåda / pallkrage', 'pallkrage odlingslåda'),
      AffiliateProduct('🥬', 'Nät mot insekter', 'insektsnät odling'),
      AffiliateProduct('🧴', 'Naturlig gödning', 'benmjöl hönsgödsel'),
    ],
    PlantCategory.kryddor: [
      AffiliateProduct('🪴', 'Krukor för örter', 'krukor örtkrukor'),
      AffiliateProduct('🧪', 'Såjord för örter', 'såjord örtjord'),
      AffiliateProduct('💡', 'Fönsterbelysning', 'växtbelysning fönster'),
    ],
    PlantCategory.blommor: [
      AffiliateProduct('🌸', 'Blomsterlök', 'blomsterlök'),
      AffiliateProduct('🧴', 'Blomgödning', 'blomgödsel'),
      AffiliateProduct('🪴', 'Blomkrukor', 'blomkrukor utomhus'),
    ],
    PlantCategory.bar: [
      AffiliateProduct('🪵', 'Stödnät / spaljé', 'spaljé bärbuske'),
      AffiliateProduct('🧴', 'Bärgödsel', 'bärgödsel ekologisk'),
      AffiliateProduct('🕸️', 'Bärnät mot fåglar', 'fågelnät bärbuskar'),
    ],
    PlantCategory.frukttrad: [
      AffiliateProduct('✂️', 'Beskärningssax', 'beskärningssax fruktträd'),
      AffiliateProduct('🎨', 'Stammålning vit', 'stammålning kalkvätska'),
      AffiliateProduct('🧴', 'Fruktträdsgödsel', 'fruktträdsgödsel'),
      AffiliateProduct('🐛', 'Limring mot insekter', 'limring insektsring'),
    ],
    PlantCategory.ovriga: [
      AffiliateProduct('🪴', 'Planteringsjord', 'planteringsjord'),
      AffiliateProduct('🧤', 'Trädgårdshandskar', 'trädgårdshandskar'),
    ],
  };

  /// Returns Amazon-search URL for a product query (with affiliate tag).
  static String urlFor(String query) => AppConstants.amazonUrl(query);

  /// Returns contextual products for a specific plant.
  static List<AffiliateProduct> productsForPlant(Plant plant) {
    final seeds = AffiliateProduct(
      plant.kategori.emoji,
      '${plant.namnSv} – frön',
      plant.amazonSokord,
    );
    final category = byCategory[plant.kategori] ?? const [];
    return [seeds, ...category.take(3)];
  }

  /// Returns starter-kit for new gardeners.
  static List<AffiliateProduct> starterProducts() => starterKit;

  /// Returns frost-protection items.
  static List<AffiliateProduct> frostProducts() => frostProtection;

  /// Returns förså-kit items.
  static List<AffiliateProduct> forsaProducts() => forsaKit;

  /// Bundles tied to monthly guide sections. Keys must match
  /// [GuideSection.affiliateBundle] values in `data/monthly_guides.dart`.
  static const Map<String, List<AffiliateProduct>> bundles = {
    'grow_lights': [
      AffiliateProduct('💡', 'Växtbelysning LED', 'växtbelysning led odling'),
      AffiliateProduct('📦', 'Odlingsbrätte med lock', 'odlingsbrätte lock'),
      AffiliateProduct('🌡️', 'Värmematta för sådd', 'värmematta sådd'),
      AffiliateProduct('🧪', 'Såjord', 'såjord torvjord'),
      AffiliateProduct('🏷️', 'Plantetiketter', 'plantetiketter trädgård'),
    ],
    'indoor_grow': [
      AffiliateProduct('🥬', 'Hydrokultur-set', 'hydrokultur inomhus'),
      AffiliateProduct('💡', 'Fönsterbelysning växter', 'växtbelysning fönster'),
      AffiliateProduct('🌱', 'Ärtskotts-frön', 'ärtskott frön mungbönor'),
      AffiliateProduct('🪴', 'Örtkrukor set', 'örtkrukor inomhus'),
      AffiliateProduct('🥒', 'Busktomat-frön', 'busktomat frön'),
    ],
    'winter_sowing': [
      AffiliateProduct('❄️', 'Fiberduk', 'fiberduk odling'),
      AffiliateProduct('🧪', 'Kallgroende frön', 'kallgroende frön perenna'),
      AffiliateProduct('🥕', 'Morotsfrön', 'morötter frön'),
      AffiliateProduct('🌿', 'Dillfrön', 'dill frön'),
      AffiliateProduct('🪵', 'Markväv', 'markväv ogräsduk'),
    ],
    'forsa_kit': forsaKit,
    'tomato_kit': [
      AffiliateProduct('🍅', 'Tomatfrön mix', 'tomat frön blandning'),
      AffiliateProduct('🪴', 'Tomatkrukor 10L', 'kruka 10 liter tomat'),
      AffiliateProduct('🪵', 'Tomatpinnar / spaljé', 'tomatpinne spaljé'),
      AffiliateProduct('🧴', 'Tomatgödsel', 'tomatgödsel ekologisk'),
      AffiliateProduct('📦', 'Odlingsbrätte', 'odlingsbrätte sådd'),
    ],
    'potato_kit': [
      AffiliateProduct('🥔', 'Sättpotatis färsk', 'sättpotatis'),
      AffiliateProduct('🪵', 'Potatissäck / odlingssäck', 'potatissäck odling'),
      AffiliateProduct('🧴', 'Potatisgödsel', 'potatisgödsel'),
      AffiliateProduct('📦', 'Förgro-bricka', 'förgroningsbricka potatis'),
    ],
    'pallkrage': [
      AffiliateProduct('🪵', 'Pallkrage', 'pallkrage odlingslåda'),
      AffiliateProduct('🪨', 'Planteringsjord', 'planteringsjord pallkrage'),
      AffiliateProduct('🥬', 'Insektsnät', 'insektsnät pallkrage'),
      AffiliateProduct('🧴', 'Kompostjord', 'kompostjord säck'),
      AffiliateProduct('🏷️', 'Plantetiketter', 'plantetiketter'),
    ],
    'flower_seeds': [
      AffiliateProduct('🌼', 'Ettåriga blommor-mix', 'sommarblommor frön mix'),
      AffiliateProduct('🌻', 'Solrosfrön', 'solrosor frön'),
      AffiliateProduct('🌸', 'Tagetes-frön', 'tagetes frön'),
      AffiliateProduct('🌺', 'Ringblomma-frön', 'ringblomma frön'),
      AffiliateProduct('🧴', 'Blomgödsel', 'blomgödsel ekologisk'),
    ],
    'spring_outdoor': [
      AffiliateProduct('🌱', 'Frön vårsådd', 'frön vårsådd trädgård'),
      AffiliateProduct('🪨', 'Såjord', 'såjord påse'),
      AffiliateProduct('🪵', 'Odlingsbågar', 'odlingsbågar fiberduk'),
      AffiliateProduct('🧤', 'Trädgårdshandskar', 'trädgårdshandskar'),
      AffiliateProduct('🛠️', 'Handspade', 'handspade planterare'),
    ],
    'sattlok': [
      AffiliateProduct('🧅', 'Sättlök gul', 'sättlök gul'),
      AffiliateProduct('🧄', 'Vitlöksklyftor', 'vitlök sätta'),
      AffiliateProduct('🌱', 'Purjolöksplantor', 'purjolök plantor'),
      AffiliateProduct('🧴', 'Löksäck / nät', 'lök säck förvaring'),
    ],
    'fiberduk': [
      AffiliateProduct('❄️', 'Fiberduk', 'fiberduk frostskydd'),
      AffiliateProduct('🪵', 'Odlingsbågar', 'odlingsbågar plast'),
      AffiliateProduct('🌡️', 'Min/Max-termometer', 'min max termometer trädgård'),
      AffiliateProduct('🏠', 'Mini-växthus', 'odlingshus mini växthus'),
    ],
    'harvest': [
      AffiliateProduct('🧺', 'Skördekorg', 'skördekorg trädgård'),
      AffiliateProduct('✂️', 'Skördesax', 'skördesax trädgård'),
      AffiliateProduct('🫙', 'Konserveringsburkar', 'konserveringsburkar glas'),
      AffiliateProduct('🥒', 'Picklings-set', 'pickling syltning set'),
      AffiliateProduct('🧂', 'Torkapparat', 'torkapparat frukt grönsaker'),
    ],
    'perennials': [
      AffiliateProduct('🌿', 'Perenna plantor-mix', 'perenner plantor'),
      AffiliateProduct('🪴', 'Planteringsjord', 'planteringsjord perenner'),
      AffiliateProduct('🧴', 'Benmjöl / gödsel', 'benmjöl perenner'),
      AffiliateProduct('✂️', 'Beskärningssax', 'beskärningssax perenner'),
    ],
    'autumn_bulbs': [
      AffiliateProduct('🌷', 'Tulpanlökar', 'tulpanlök höst'),
      AffiliateProduct('🌼', 'Narcisslökar', 'narcisslök påsklilja'),
      AffiliateProduct('💜', 'Krokuslökar', 'krokus höstplantering'),
      AffiliateProduct('🌺', 'Hyacintlökar', 'hyacint lök'),
      AffiliateProduct('🛠️', 'Lökplanterare', 'lökplanterare verktyg'),
    ],
    'propagation': [
      AffiliateProduct('✂️', 'Sticklingskniv', 'sticklingskniv ympkniv'),
      AffiliateProduct('🧪', 'Rotpulver', 'rotpulver sticklingar'),
      AffiliateProduct('🪴', 'Sticklingskrukor', 'sticklingskrukor små'),
      AffiliateProduct('🏠', 'Mini-växthus', 'mini växthus sticklingar'),
    ],
  };

  /// Returns product list for a given bundle key. Empty if unknown.
  static List<AffiliateProduct> productsForBundle(String? key) {
    if (key == null) return const [];
    return bundles[key] ?? const [];
  }

  /// Aggregated list of products relevant to the given month (1-12).
  /// Used by the home screen to surface "Månadens produkter".
  static const Map<int, List<String>> _monthBundles = {
    1: ['grow_lights', 'indoor_grow', 'winter_sowing'],
    2: ['grow_lights', 'forsa_kit', 'indoor_grow'],
    3: ['forsa_kit', 'tomato_kit', 'potato_kit'],
    4: ['pallkrage', 'forsa_kit', 'flower_seeds'],
    5: ['spring_outdoor', 'sattlok', 'fiberduk'],
    6: ['spring_outdoor', 'flower_seeds', 'tomato_kit'],
    7: ['harvest', 'spring_outdoor', 'perennials'],
    8: ['harvest', 'autumn_bulbs', 'perennials'],
    9: ['autumn_bulbs', 'harvest', 'winter_sowing'],
    10: ['autumn_bulbs', 'perennials', 'propagation'],
    11: ['winter_sowing', 'sattlok', 'indoor_grow'],
    12: ['grow_lights', 'winter_sowing', 'flower_seeds'],
  };

  /// Returns up to [limit] curated products for the given month.
  static List<AffiliateProduct> productsForMonth(int month, {int limit = 6}) {
    final keys = _monthBundles[month] ?? const [];
    final seen = <String>{};
    final result = <AffiliateProduct>[];
    for (final key in keys) {
      for (final p in productsForBundle(key)) {
        if (seen.add(p.query)) result.add(p);
        if (result.length >= limit) return result;
      }
    }
    return result;
  }
}
