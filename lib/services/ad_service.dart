import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // TODO: Replace with real Plantera AdMob IDs when account is set up.
  static const String appIdAndroid = '';
  static const String appIdIos = '';

  static const String bannerAdUnitIdAndroid = '';
  static const String bannerAdUnitIdIos = '';
  static const String interstitialAdUnitIdAndroid = '';
  static const String interstitialAdUnitIdIos = '';
  static const String rewardedAdUnitIdAndroid = '';
  static const String rewardedAdUnitIdIos = '';
  static const String appOpenAdUnitIdAndroid = '';
  static const String appOpenAdUnitIdIos = '';

  static const String testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';
  static const String testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
  static const String testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String testRewardedIos =
      'ca-app-pub-3940256099942544/1712485313';
  static const String testAppOpenAndroid =
      'ca-app-pub-3940256099942544/9257395921';
  static const String testAppOpenIos =
      'ca-app-pub-3940256099942544/5575463023';

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  int _interstitialCloseCounter = 0;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;
  bool _isShowingAppOpenAd = false;
  DateTime? _appOpenAdLoadTime;

  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_isInitialized) return;

    await _requestConsentInfo();
    await MobileAds.instance.initialize();
    _isInitialized = true;
    loadAppOpenAd();
    loadRewardedAd();
    loadInterstitial();
  }

  Future<void> _requestConsentInfo() async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => completer.complete(),
      (FormError error) {
        debugPrint('[AdService] Consent info failed: ${error.message}');
        completer.complete();
      },
    );
    return completer.future;
  }

  Future<void> showConsentFormIfNeeded() async {
    if (kIsWeb) return;
    try {
      final isAvailable =
          await ConsentInformation.instance.isConsentFormAvailable();
      if (!isAvailable) return;
      final completer = Completer<void>();
      ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          debugPrint('[AdService] Consent form error: ${error.message}');
        }
        completer.complete();
      });
      await completer.future;
    } catch (e) {
      debugPrint('[AdService] showConsentFormIfNeeded error: $e');
    }
  }

  static String getBannerAdUnitId() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    final isIos = !kIsWeb && Platform.isIOS;
    if (isRelease) {
      final prod = isIos ? bannerAdUnitIdIos : bannerAdUnitIdAndroid;
      if (prod.isNotEmpty) return prod;
    }
    return isIos ? testBannerIos : testBannerAndroid;
  }

  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static String getInterstitialAdUnitId() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    final isIos = !kIsWeb && Platform.isIOS;
    if (isRelease) {
      final prod =
          isIos ? interstitialAdUnitIdIos : interstitialAdUnitIdAndroid;
      if (prod.isNotEmpty) return prod;
    }
    return isIos ? testInterstitialIos : testInterstitialAndroid;
  }

  Future<void> loadInterstitial() async {
    if (kIsWeb) return;
    if (_interstitialAd != null) return;
    await InterstitialAd.load(
      adUnitId: getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Interstitial failed: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  Future<bool> maybeShowInterstitial({int frequency = 3}) async {
    if (kIsWeb) return false;
    _interstitialCloseCounter++;
    if (_interstitialCloseCounter % frequency != 0) {
      loadInterstitial();
      return false;
    }
    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitial();
      return false;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
    );
    await ad.show();
    return true;
  }

  static String getRewardedAdUnitId() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    final isIos = !kIsWeb && Platform.isIOS;
    if (isRelease) {
      final prod = isIos ? rewardedAdUnitIdIos : rewardedAdUnitIdAndroid;
      if (prod.isNotEmpty) return prod;
    }
    return isIos ? testRewardedIos : testRewardedAndroid;
  }

  Future<void> loadRewardedAd() async {
    if (kIsWeb) return;
    if (_rewardedAd != null) return;
    await RewardedAd.load(
      adUnitId: getRewardedAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded failed: ${error.message}');
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (kIsWeb) return false;
    final ad = _rewardedAd;
    if (ad == null) {
      loadRewardedAd();
      return false;
    }
    final completer = Completer<bool>();
    bool rewarded = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        completer.complete(rewarded);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        completer.complete(false);
      },
    );
    await ad.show(onUserEarnedReward: (ad, reward) {
      rewarded = true;
    });
    return completer.future;
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  static String getAppOpenAdUnitId() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    final isIos = !kIsWeb && Platform.isIOS;
    if (isRelease) {
      final prod = isIos ? appOpenAdUnitIdIos : appOpenAdUnitIdAndroid;
      if (prod.isNotEmpty) return prod;
    }
    return isIos ? testAppOpenIos : testAppOpenAndroid;
  }

  void loadAppOpenAd() {
    if (kIsWeb) return;
    AppOpenAd.load(
      adUnitId: getAppOpenAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAdLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] App open failed: ${error.message}');
          _appOpenAd = null;
        },
      ),
    );
  }

  bool get _isAppOpenAdAvailable {
    if (_appOpenAd == null || _appOpenAdLoadTime == null) return false;
    return DateTime.now().difference(_appOpenAdLoadTime!).inHours < 4;
  }

  Future<void> showAppOpenAd() async {
    if (kIsWeb) return;
    if (_isShowingAppOpenAd) return;
    if (!_isAppOpenAdAvailable) {
      loadAppOpenAd();
      return;
    }
    _isShowingAppOpenAd = true;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _isShowingAppOpenAd = false;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        _isShowingAppOpenAd = false;
        loadAppOpenAd();
      },
    );
    await _appOpenAd!.show();
  }
}
