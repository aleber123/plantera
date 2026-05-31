import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PremiumPlan { free, monthly, yearly, lifetime }

class PremiumService extends ChangeNotifier {
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  PremiumService._internal();

  static const String _premiumKey = 'is_premium_lifetime';
  static const String _planKey = 'premium_plan';
  static const String _subPlanKey = 'sub_plan';
  static const String _subActivatedAtKey = 'sub_activated_at_ms';

  /// Local-clock grace window for subscriptions. StoreKit remains the
  /// source of truth — every launch we re-call restorePurchases so
  /// renewals refresh the activation stamp and cancellations stop
  /// extending it. The grace prevents premium from flipping to free if
  /// the user is offline for a few days.
  static const Duration _monthlyGrace = Duration(days: 32);
  static const Duration _yearlyGrace = Duration(days: 367);
  static const String _tempPremiumExpiryKey = 'temp_premium_expiry';

  static const String monthlyId =
      'com.alexanderbergqvist.plantera.sub.monthly';
  static const String yearlyId =
      'com.alexanderbergqvist.plantera.sub.yearly';
  static const String lifetimeId =
      'com.alexanderbergqvist.plantera.lifetime';

  static const Set<String> _productIds = {monthlyId, yearlyId, lifetimeId};

  // Free-tier limits for Plantera
  static const int maxFreeGardenPlants = 5;
  static const int maxFreeReminders = 3;

  // Fallback prices in SEK – real prices from App Store Connect.
  static const Map<PremiumPlan, double> _fallbackPricesSek = {
    PremiumPlan.monthly: 39,
    PremiumPlan.yearly: 199,
    PremiumPlan.lifetime: 399,
  };

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _storeAvailable = false;

  bool _isPremium = false;
  PremiumPlan _currentPlan = PremiumPlan.free;
  bool _purchaseInProgress = false;
  String? _purchaseError;
  DateTime? _tempPremiumExpiry;
  Timer? _tempExpiryTicker;
  PremiumPlan? _activeSubPlan;
  DateTime? _subActivatedAt;

  bool get isPremium =>
      _isPremium || _isTempPremium || _hasActiveSubscription;
  bool get _isTempPremium {
    if (_tempPremiumExpiry == null) return false;
    return DateTime.now().isBefore(_tempPremiumExpiry!);
  }

  /// True when a previously-confirmed monthly/yearly purchase is still
  /// inside its grace window. Set by [_verifyAndActivate] (called on
  /// fresh purchase + on every restore on app launch). If the user
  /// cancels and the next launch's restorePurchases doesn't refresh
  /// the stamp, this expires automatically once the grace runs out.
  bool get _hasActiveSubscription {
    final plan = _activeSubPlan;
    final at = _subActivatedAt;
    if (plan == null || at == null) return false;
    final grace = plan == PremiumPlan.yearly ? _yearlyGrace : _monthlyGrace;
    return DateTime.now().isBefore(at.add(grace));
  }

  /// Schedules a single-shot timer that fires precisely when the temp
  /// premium expires, so widgets get a refresh notification at the
  /// flip-over instant — otherwise UI showing premium state goes stale
  /// until the next user action.
  void _scheduleTempExpiryNotify() {
    _tempExpiryTicker?.cancel();
    _tempExpiryTicker = null;
    final expiry = _tempPremiumExpiry;
    if (expiry == null) return;
    final delta = expiry.difference(DateTime.now());
    if (delta <= Duration.zero) return;
    _tempExpiryTicker = Timer(delta, () {
      _tempExpiryTicker = null;
      notifyListeners();
    });
  }

  PremiumPlan get currentPlan => _currentPlan;
  bool get purchaseInProgress => _purchaseInProgress;
  String? get purchaseError => _purchaseError;
  List<ProductDetails> get products => _products;
  bool get storeAvailable => _storeAvailable;

  Future<void> grantTemporaryPremium(
      {Duration duration = const Duration(hours: 24)}) async {
    final expiry = DateTime.now().add(duration);
    _tempPremiumExpiry = expiry;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tempPremiumExpiryKey, expiry.millisecondsSinceEpoch);
    _scheduleTempExpiryNotify();
    notifyListeners();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final tempExpiry = prefs.getInt(_tempPremiumExpiryKey);
    if (tempExpiry != null) {
      _tempPremiumExpiry = DateTime.fromMillisecondsSinceEpoch(tempExpiry);
      _scheduleTempExpiryNotify();
    }

    // Restore the cached subscription stamp. The grace window in
    // [_hasActiveSubscription] prevents premium going dark while
    // the user is offline; restorePurchases() below refreshes it on
    // every successful launch.
    final subPlanIndex = prefs.getInt(_subPlanKey);
    final subAtMs = prefs.getInt(_subActivatedAtKey);
    if (subPlanIndex != null && subAtMs != null) {
      final plan = PremiumPlan.values[subPlanIndex];
      if (plan == PremiumPlan.monthly || plan == PremiumPlan.yearly) {
        _activeSubPlan = plan;
        _subActivatedAt = DateTime.fromMillisecondsSinceEpoch(subAtMs);
      }
    }

    final cachedPlanIndex = prefs.getInt(_planKey) ?? 0;
    final cachedPlan = PremiumPlan.values[cachedPlanIndex];
    if (cachedPlan == PremiumPlan.lifetime &&
        (prefs.getBool(_premiumKey) ?? false)) {
      _isPremium = true;
      _currentPlan = PremiumPlan.lifetime;
    } else {
      _isPremium = false;
      _currentPlan = PremiumPlan.free;
      await prefs.setBool(_premiumKey, false);
      await prefs.setInt(_planKey, 0);
    }

    try {
      _storeAvailable = await _iap.isAvailable();
      if (_storeAvailable) {
        _subscription = _iap.purchaseStream.listen(
          _onPurchaseUpdated,
          onDone: () => _subscription?.cancel(),
          onError: (error) => debugPrint('IAP stream error: $error'),
        );
        await _loadProducts();
        await _iap.restorePurchases();
      }
    } catch (e) {
      debugPrint('IAP initialization failed: $e');
      _storeAvailable = false;
    }

    notifyListeners();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    if (response.error != null) {
      debugPrint('IAP query error: ${response.error}');
    }
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('IAP products not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    notifyListeners();
  }

  /// Manually re-fetch product details. Called from the paywall when the
  /// user opens it — covers the case where the initial app-launch fetch
  /// happened before StoreKit was warm (common in sandbox / TestFlight /
  /// App Review environments where products propagate slowly).
  Future<bool> reloadProducts() async {
    if (!_storeAvailable) {
      _storeAvailable = await _iap.isAvailable();
      if (!_storeAvailable) return false;
    }
    await _loadProducts();
    return _products.isNotEmpty;
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _purchaseInProgress = true;
          _purchaseError = null;
          notifyListeners();
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndActivate(purchase);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;

        case PurchaseStatus.error:
          _purchaseInProgress = false;
          _purchaseError = purchase.error?.message ?? 'purchase_failed';
          notifyListeners();
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;

        case PurchaseStatus.canceled:
          _purchaseInProgress = false;
          _purchaseError = null;
          notifyListeners();
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
      }
    }
  }

  Future<void> _verifyAndActivate(PurchaseDetails purchase) async {
    PremiumPlan plan = PremiumPlan.free;
    if (purchase.productID == monthlyId) {
      plan = PremiumPlan.monthly;
    } else if (purchase.productID == yearlyId) {
      plan = PremiumPlan.yearly;
    } else if (purchase.productID == lifetimeId) {
      plan = PremiumPlan.lifetime;
    }

    if (plan != PremiumPlan.free) {
      _currentPlan = plan;
      final prefs = await SharedPreferences.getInstance();

      if (plan == PremiumPlan.lifetime) {
        _isPremium = true;
        await prefs.setBool(_premiumKey, true);
        await prefs.setInt(_planKey, plan.index);
      } else {
        // monthly / yearly: stamp activation so the grace window
        // counts from now. Restoring an already-active sub on a fresh
        // device launch refreshes this stamp every time, so a happy
        // user is always inside the window.
        _activeSubPlan = plan;
        _subActivatedAt = DateTime.now();
        await prefs.setInt(_subPlanKey, plan.index);
        await prefs.setInt(
            _subActivatedAtKey, _subActivatedAt!.millisecondsSinceEpoch);
      }
    }

    _purchaseInProgress = false;
    _purchaseError = null;
    notifyListeners();
  }

  // --- Gating helpers ---
  bool canAddGardenPlant(int currentCount) {
    if (isPremium) return true;
    return currentCount < maxFreeGardenPlants;
  }

  bool canAddReminder(int currentCount) {
    if (isPremium) return true;
    return currentCount < maxFreeReminders;
  }

  bool get isAdFree => isPremium;
  bool get canExport => isPremium;
  bool get canUseAdvancedCalendar => isPremium;
  bool get canUsePhotoLog => isPremium;
  bool get canAccessAllKnowledge => isPremium;

  // --- Price helpers ---
  String getPrice(PremiumPlan plan, String languageCode) {
    final productId = _planToProductId(plan);
    final storeProduct = _products.where((p) => p.id == productId).firstOrNull;
    if (storeProduct != null) return storeProduct.price;
    final price = _fallbackPricesSek[plan] ?? 0;
    return '${price.toInt()} kr';
  }

  int getYearlySavingsPercent(String languageCode) {
    final monthlyStore = _products.where((p) => p.id == monthlyId).firstOrNull;
    final yearlyStore = _products.where((p) => p.id == yearlyId).firstOrNull;

    double monthly;
    double yearly;
    if (monthlyStore != null && yearlyStore != null) {
      monthly = monthlyStore.rawPrice;
      yearly = yearlyStore.rawPrice;
    } else {
      monthly = _fallbackPricesSek[PremiumPlan.monthly] ?? 0;
      yearly = _fallbackPricesSek[PremiumPlan.yearly] ?? 0;
    }
    if (monthly <= 0 || yearly <= 0) return 0;
    final fullYear = monthly * 12;
    final percent = ((fullYear - yearly) / fullYear) * 100;
    return percent.round().clamp(0, 99);
  }

  String getMonthlyEquivalent(PremiumPlan plan, String languageCode) {
    if (plan != PremiumPlan.yearly) return '';
    final perMonthSuffix = _perMonthSuffix(languageCode);
    final productId = _planToProductId(plan);
    final storeProduct = _products.where((p) => p.id == productId).firstOrNull;
    if (storeProduct != null) {
      final monthly = storeProduct.rawPrice / 12;
      final currencyCode = storeProduct.currencyCode;
      return '${monthly.toStringAsFixed(0)} $currencyCode$perMonthSuffix';
    }
    final yearly = _fallbackPricesSek[PremiumPlan.yearly] ?? 0;
    return '${(yearly / 12).toInt()} kr$perMonthSuffix';
  }

  /// Locale-aware "/month" suffix appended to currency-amount strings. The
  /// previous hardcoded "/mån" leaked Swedish into every other locale. Falls
  /// back to English when the user's locale isn't in our supported list.
  String _perMonthSuffix(String lang) {
    return switch (lang) {
      'sv' => '/mån',
      'nb' || 'da' => '/md.',
      'fi' => '/kk',
      'de' => '/Mon.',
      'fr' => '/mois',
      'es' => '/mes',
      'it' => '/mese',
      'el' => '/μήνα',
      _ => '/mo',
    };
  }

  /// Returns just the trial PERIOD text (e.g. "7 days" / "7 dagar") in the
  /// caller's locale — the surrounding "free trial" copy lives in the ARB
  /// template `paywallTrialCta`. Returns null when no intro free-trial is
  /// configured for this plan. Non-iOS platforms always return null since
  /// only StoreKit exposes intro-offer metadata.
  String? introOfferText(PremiumPlan plan, String languageCode) {
    if (!Platform.isIOS) return null;
    final productId = _planToProductId(plan);
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (product is! AppStoreProductDetails) return null;

    final intro = product.skProduct.introductoryPrice;
    if (intro == null) return null;
    if (intro.paymentMode != SKProductDiscountPaymentMode.freeTrail) return null;

    var units = intro.subscriptionPeriod.numberOfUnits;
    var unit = intro.subscriptionPeriod.unit;
    // Apple sends "1 week" for a 7-day trial — convert to days because
    // every language has a clean plural for days, but week-day mixing
    // ("1 vecka" / "1 week") looks oddly short next to "Start free trial".
    if (unit == SKSubscriptionPeriodUnit.week && units == 1) {
      units = 7;
      unit = SKSubscriptionPeriodUnit.day;
    }
    return _localizedTrialPeriod(units, unit, languageCode);
  }

  /// Locale-aware "{N} {unit}" period rendering. Hardcoded per language so
  /// we don't have to thread BuildContext into the service. Falls back to
  /// English for unsupported locales.
  String _localizedTrialPeriod(
      int units, SKSubscriptionPeriodUnit unit, String lang) {
    final labels = _trialUnitLabels[lang] ?? _trialUnitLabels['en']!;
    final key = switch (unit) {
      SKSubscriptionPeriodUnit.day => units == 1 ? 'day1' : 'dayN',
      SKSubscriptionPeriodUnit.week => units == 1 ? 'week1' : 'weekN',
      SKSubscriptionPeriodUnit.month => units == 1 ? 'month1' : 'monthN',
      SKSubscriptionPeriodUnit.year => units == 1 ? 'year1' : 'yearN',
    };
    return '$units ${labels[key]!}';
  }

  /// Singular + plural unit labels per supported locale. Greek and Finnish
  /// use the nominative form (the ARB template wraps the period in parens
  /// so we sidestep case agreement: "Aloita ilmainen kokeilu (7 päivää)").
  static const Map<String, Map<String, String>> _trialUnitLabels = {
    'sv': {
      'day1': 'dag', 'dayN': 'dagar',
      'week1': 'vecka', 'weekN': 'veckor',
      'month1': 'månad', 'monthN': 'månader',
      'year1': 'år', 'yearN': 'år',
    },
    'en': {
      'day1': 'day', 'dayN': 'days',
      'week1': 'week', 'weekN': 'weeks',
      'month1': 'month', 'monthN': 'months',
      'year1': 'year', 'yearN': 'years',
    },
    'nb': {
      'day1': 'dag', 'dayN': 'dager',
      'week1': 'uke', 'weekN': 'uker',
      'month1': 'måned', 'monthN': 'måneder',
      'year1': 'år', 'yearN': 'år',
    },
    'da': {
      'day1': 'dag', 'dayN': 'dage',
      'week1': 'uge', 'weekN': 'uger',
      'month1': 'måned', 'monthN': 'måneder',
      'year1': 'år', 'yearN': 'år',
    },
    'fi': {
      'day1': 'päivä', 'dayN': 'päivää',
      'week1': 'viikko', 'weekN': 'viikkoa',
      'month1': 'kuukausi', 'monthN': 'kuukautta',
      'year1': 'vuosi', 'yearN': 'vuotta',
    },
    'de': {
      'day1': 'Tag', 'dayN': 'Tage',
      'week1': 'Woche', 'weekN': 'Wochen',
      'month1': 'Monat', 'monthN': 'Monate',
      'year1': 'Jahr', 'yearN': 'Jahre',
    },
    'fr': {
      'day1': 'jour', 'dayN': 'jours',
      'week1': 'semaine', 'weekN': 'semaines',
      'month1': 'mois', 'monthN': 'mois',
      'year1': 'an', 'yearN': 'ans',
    },
    'es': {
      'day1': 'día', 'dayN': 'días',
      'week1': 'semana', 'weekN': 'semanas',
      'month1': 'mes', 'monthN': 'meses',
      'year1': 'año', 'yearN': 'años',
    },
    'it': {
      'day1': 'giorno', 'dayN': 'giorni',
      'week1': 'settimana', 'weekN': 'settimane',
      'month1': 'mese', 'monthN': 'mesi',
      'year1': 'anno', 'yearN': 'anni',
    },
    'el': {
      'day1': 'ημέρα', 'dayN': 'ημέρες',
      'week1': 'εβδομάδα', 'weekN': 'εβδομάδες',
      'month1': 'μήνας', 'monthN': 'μήνες',
      'year1': 'χρόνος', 'yearN': 'χρόνια',
    },
  };

  String _planToProductId(PremiumPlan plan) {
    switch (plan) {
      case PremiumPlan.monthly:
        return monthlyId;
      case PremiumPlan.yearly:
        return yearlyId;
      case PremiumPlan.lifetime:
        return lifetimeId;
      case PremiumPlan.free:
        return '';
    }
  }

  // --- Purchase ---
  Future<bool> purchase(PremiumPlan plan) async {
    if (!_storeAvailable) {
      // StoreKit may not have been ready when the service first
      // initialized — try probing again before giving up.
      _storeAvailable = await _iap.isAvailable();
      if (!_storeAvailable) {
        _purchaseError = 'store_not_available';
        notifyListeners();
        return false;
      }
    }
    final productId = _planToProductId(plan);
    var product = _products.where((p) => p.id == productId).firstOrNull;
    if (product == null) {
      // Sandbox / TestFlight / App Review environments often deliver IAP
      // metadata after the app has already loaded. Give StoreKit one
      // more chance before reporting back to the UI.
      debugPrint('IAP product missing — retrying queryProductDetails');
      await _loadProducts();
      product = _products.where((p) => p.id == productId).firstOrNull;
    }
    if (product == null) {
      _purchaseError = 'product_not_found';
      notifyListeners();
      return false;
    }

    _purchaseInProgress = true;
    _purchaseError = null;
    notifyListeners();

    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      final success =
          await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      debugPrint('IAP buyProduct returned: $success');
    } catch (e) {
      _purchaseInProgress = false;
      // User-cancellations from StoreKit / Google Play often surface
      // here as exceptions on some platforms instead of via the
      // PurchaseStatus.canceled branch. Silence them — surfacing an
      // error after the user explicitly tapped Cancel is confusing.
      final msg = e.toString().toLowerCase();
      final isCancel = msg.contains('cancel') ||
          msg.contains('skerrorpaymentcancelled') ||
          msg.contains('user_canceled');
      _purchaseError = isCancel ? null : 'purchase_failed';
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> restorePurchases() async {
    if (!_storeAvailable) return false;
    try {
      await _iap.restorePurchases();
      return true;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
