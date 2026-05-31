import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/premium_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class PaywallScreen extends StatefulWidget {
  /// Identifies WHERE in the app the user opened the paywall from, so the
  /// title + subtitle can lean into the specific need that drove them here
  /// (frost warnings, plant cap, photo gate, etc.) instead of a generic
  /// "Plantera Premium" headline. Falls back to the generic copy when no
  /// source is set or when the source isn't mapped.
  final String source;

  const PaywallScreen({super.key, this.source = 'default'});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  @override
  void initState() {
    super.initState();
    // Force a fresh product fetch when the paywall opens so the buy
    // button never silently no-ops just because the initial app-launch
    // fetch missed (common in sandbox / TestFlight / App Review).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PremiumService>().reloadProducts();
    });
  }

  Future<void> _onBuy(PremiumService premium, PremiumPlan plan) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context);
    final ok = await premium.purchase(plan);
    if (!mounted) return;
    if (ok) {
      // Close paywall on success so the user actually sees the app
      // unlocked instead of staring at the same paywall. Audit found
      // users would tap Buy, see nothing change, and bail.
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.paywallPurchaseSuccess)),
      );
      navigator.pop();
      return;
    }
    final reason = switch (premium.purchaseError) {
      'store_not_available' => l10n.paywallErrorStore,
      'product_not_found' => l10n.paywallErrorProduct,
      _ => l10n.paywallErrorFailed,
    };
    messenger.showSnackBar(SnackBar(content: Text(reason)));
  }

  /// Restore Purchases with real UX feedback.
  ///
  /// PremiumService.restorePurchases() returns true if the StoreKit
  /// call succeeded, NOT if anything was actually restored. The real
  /// result comes asynchronously via the purchase-update stream.
  /// Polls premium.isPremium for a few seconds to detect a flip and
  /// surfaces an appropriate snackbar.
  Future<void> _onRestore(PremiumService premium) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.paywallRestoreInProgress)),
    );
    final wasPremium = premium.isPremium;
    final ok = await premium.restorePurchases();
    if (!mounted) return;
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.paywallRestoreFailed)),
      );
      return;
    }
    // Up to 4s for the purchase-update stream to flip isPremium.
    for (var i = 0; i < 8; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (premium.isPremium && !wasPremium) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.paywallRestoreSuccess)),
        );
        navigator.pop();
        return;
      }
    }
    if (!mounted) return;
    if (premium.isPremium) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.paywallRestoreAlreadyActive)),
      );
      navigator.pop();
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.paywallRestoreNothingFound)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitleBranded)),
      body: Consumer<PremiumService>(
        builder: (ctx, premium, _) {
          // If the user is already Premium (subscription active OR
          // lifetime purchased), don't show plan-selection CTAs. Show
          // a thank-you / status panel instead so they don't double-
          // purchase out of confusion.
          if (premium.isPremium) {
            return _AlreadyPremium(l10n: l10n);
          }
          // Store down / products list empty after reload — surface
          // a clear error + retry instead of a frozen plan list with
          // "Pris kommer snart"-buttons.
          final productsMissing =
              !premium.storeAvailable || premium.products.isEmpty;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('🌿',
                  style: TextStyle(fontSize: 64),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                _headerForSource(widget.source, l10n),
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _subForSource(widget.source, l10n),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              if (productsMissing) ...[
                const SizedBox(height: 20),
                _ProductLoadFallback(
                  l10n: l10n,
                  onRetry: () => premium.reloadProducts(),
                ),
              ],
              const SizedBox(height: 20),
              _benefit(Icons.all_inclusive, l10n.paywallBenefitUnlimited),
              _benefit(
                  Icons.notifications_active, l10n.paywallBenefitReminders),
              _benefit(Icons.photo_library, l10n.paywallBenefitPhotos),
              _benefit(Icons.block, l10n.paywallBenefitNoAds),
              _benefit(Icons.picture_as_pdf, l10n.paywallBenefitPdf),
              _benefit(Icons.menu_book, l10n.paywallBenefitArticles),
              const SizedBox(height: 20),
              // Apple 3.1.2(c): EULA + Privacy MUST be in a bordered
              // block ABOVE the purchase CTAs. The 3-button layout
              // here is a known UX wart we'll fix next release —
              // tonight we just satisfy the legal placement so we
              // don't bounce on the next App Review.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.paywallDisclaimer,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            minimumSize: const Size(0, 28),
                          ),
                          onPressed: () =>
                              _open(ctx, AppConstants.termsOfUseUrl),
                          child: Text(l10n.paywallTerms,
                              style: const TextStyle(fontSize: 12)),
                        ),
                        const Text(' · ',
                            style: TextStyle(color: Colors.grey)),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            minimumSize: const Size(0, 28),
                          ),
                          onPressed: () =>
                              _open(ctx, AppConstants.privacyPolicyUrl),
                          child: Text(l10n.paywallPrivacy,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Only show plan buttons when products actually loaded.
              // Disabled buttons with "Pris kommer snart"-fallbacks
              // looked broken and prompted users to bail.
              if (!productsMissing) ...[
                _planButton(
                  ctx,
                  premium,
                  PremiumPlan.yearly,
                  l10n.paywallPlanYearly,
                  lang: lang,
                  l10n: l10n,
                  subtitle: l10n.paywallPlanYearlySavings(
                      '${premium.getYearlySavingsPercent(lang)}'),
                  highlight: true,
                ),
                const SizedBox(height: 10),
                _planButton(ctx, premium, PremiumPlan.monthly,
                    l10n.paywallPlanMonthly,
                    lang: lang, l10n: l10n),
                const SizedBox(height: 10),
                _planButton(ctx, premium, PremiumPlan.lifetime,
                    l10n.paywallPlanLifetime,
                    lang: lang, l10n: l10n),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: premium.purchaseInProgress
                    ? null
                    : () => _onRestore(premium),
                child: Text(l10n.paywallRestore),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Maps the entry-point identifier to a headline that leads with the
  /// specific benefit the user is reaching for. The goal is "show them
  /// the feature they came for, not a generic upgrade pitch."
  String _headerForSource(String source, AppLocalizations l10n) {
    switch (source) {
      case 'frost':
        return l10n.paywallHeaderFrost;
      case 'garden_limit':
        return l10n.paywallHeaderGardenLimit;
      case 'water_all':
        return l10n.paywallHeaderWaterAll;
      case 'photo_log':
        return l10n.paywallHeaderPhotoLog;
      case 'home':
      case 'settings':
      default:
        return l10n.paywallTitleBranded;
    }
  }

  String _subForSource(String source, AppLocalizations l10n) {
    switch (source) {
      case 'frost':
        return l10n.paywallSubFrost;
      case 'garden_limit':
        return l10n.paywallSubGardenLimit;
      case 'water_all':
        return l10n.paywallSubWaterAll;
      case 'photo_log':
        return l10n.paywallSubPhotoLog;
      case 'home':
        return l10n.paywallSubHome;
      case 'settings':
      default:
        return l10n.paywallSubDefault;
    }
  }

  Widget _benefit(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _planButton(
    BuildContext ctx,
    PremiumService premium,
    PremiumPlan plan,
    String title, {
    required String lang,
    required AppLocalizations l10n,
    String? subtitle,
    bool highlight = false,
  }) {
    final price = premium.getPrice(plan, lang);
    final intro = premium.introOfferText(plan, lang);
    // When an intro free-trial exists, swap the headline to a trial-CTA
    // — the upgrade copy ("Start 7-day free trial") is the single
    // biggest paywall conversion lever in Apple's playbook. Falls back
    // to the regular "title • price" when no offer is configured.
    final headline = intro != null
        ? l10n.paywallTrialCta(intro)
        : l10n.paywallPlanPriceFormat(title, price);
    final supporting =
        intro != null ? l10n.paywallTrialThen(price) : null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              highlight ? AppTheme.primaryGreen : Colors.grey.shade200,
          foregroundColor: highlight ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: premium.purchaseInProgress
            ? null
            : () => _onBuy(premium, plan),
        child: Column(
          children: [
            Text(
              headline,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (supporting != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(supporting, style: const TextStyle(fontSize: 12)),
              ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle, style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    // Apple requires the EULA/Privacy URL to be reachable from the
    // paywall. A silent no-op when launching fails is bad UX and is a
    // grey-area App Store violation. Surface the URL so the user can
    // open it on another device.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.paywallErrorOpenUrl(url)),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}

/// Status panel shown when the user is already Premium (active sub or
/// lifetime). Replaces the plan-selection CTAs so they don't accidentally
/// double-purchase. Includes a discreet manage-subscription link.
class _AlreadyPremium extends StatelessWidget {
  final AppLocalizations l10n;
  const _AlreadyPremium({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌿', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text(
            l10n.paywallAlreadyPremiumTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallAlreadyPremiumBody,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check),
            label: Text(l10n.paywallAlreadyPremiumCta),
          ),
        ],
      ),
    );
  }
}

/// Fallback shown when StoreKit hasn't returned products (network,
/// outage, sandbox glitch). Without this users saw an empty plan list
/// with no path to recover beyond force-quitting the app.
class _ProductLoadFallback extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onRetry;
  const _ProductLoadFallback({required this.l10n, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.signal_wifi_off, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.paywallProductsUnavailable,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.paywallProductsRetry),
            ),
          ),
        ],
      ),
    );
  }
}
