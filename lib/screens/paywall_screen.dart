import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/premium_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

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
    final ok = await premium.purchase(plan);
    if (!mounted) return;
    if (!ok) {
      final reason = switch (premium.purchaseError) {
        'store_not_available' =>
          'App Store är inte tillgängligt just nu — försök igen om en stund.',
        'product_not_found' =>
          'Köpet kunde inte laddas från App Store. Stäng paywallen och öppna igen.',
        _ => 'Köpet misslyckades. Försök igen.',
      };
      messenger.showSnackBar(SnackBar(content: Text(reason)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantera Premium')),
      body: Consumer<PremiumService>(
        builder: (ctx, premium, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('🌿', style: TextStyle(fontSize: 64),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              const Text(
                'Plantera Premium',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Växla upp din trädgård',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _benefit(Icons.all_inclusive, 'Obegränsade växter i min trädgård'),
              _benefit(Icons.notifications_active, 'Alla påminnelser och frostvarningar'),
              _benefit(Icons.photo_library, 'Fotodagbok för varje växt'),
              _benefit(Icons.block, 'Inga annonser'),
              _benefit(Icons.picture_as_pdf, 'PDF-export av skördedagbok'),
              _benefit(Icons.menu_book, 'Full tillgång till kunskapsartiklar'),
              const SizedBox(height: 20),
              _planButton(
                ctx,
                premium,
                PremiumPlan.yearly,
                'Årsprenumeration',
                subtitle:
                    'Spara ${premium.getYearlySavingsPercent('sv')}% jämfört med månad',
                highlight: true,
              ),
              const SizedBox(height: 10),
              _planButton(ctx, premium, PremiumPlan.monthly, 'Månadsprenumeration'),
              const SizedBox(height: 10),
              _planButton(ctx, premium, PremiumPlan.lifetime,
                  'Livstidsköp (engångsbetalning)'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: premium.purchaseInProgress
                    ? null
                    : () => premium.restorePurchases(),
                child: const Text('Återställ tidigare köp'),
              ),
              const SizedBox(height: 6),
              Text(
                'Prenumerationer förnyas automatiskt tills de avslutas i App Store-inställningarna. Avgiften dras 24 h före förnyelse.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _open(AppConstants.termsOfUseUrl),
                    child: const Text('Villkor (EULA)',
                        style: TextStyle(fontSize: 12)),
                  ),
                  const Text('·', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => _open(AppConstants.privacyPolicyUrl),
                    child: const Text('Integritetspolicy',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
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
    String? subtitle,
    bool highlight = false,
  }) {
    final price = premium.getPrice(plan, 'sv');
    final intro = premium.introOfferText(plan, 'sv');
    // When an intro free-trial exists, swap the headline to a trial-CTA
    // — the upgrade copy ("Starta 7 dagars gratis prov") is the single
    // biggest paywall conversion lever in Apple's playbook. Falls back
    // to the regular "title • price" when no offer is configured.
    final headline = intro != null
        ? 'Starta ${_introCtaLabel(intro)}'
        : '$title • $price';
    final supporting = intro != null ? 'Sedan $price' : null;
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

  /// Strips the "gratis" suffix off the intro offer text so we can
  /// inject it into a "Starta ___ gratis prov" sentence cleanly.
  /// Examples: "7 dagar gratis" → "7 dagars gratis prov".
  String _introCtaLabel(String intro) {
    final lower = intro.toLowerCase().trim();
    // "7 dagar gratis" / "1 vecka gratis" / "14 dagar gratis"
    if (lower.endsWith(' gratis')) {
      final period = lower.substring(0, lower.length - ' gratis'.length).trim();
      // Add "s" for genitive feel ("7 dagar" → "7 dagars prov")
      final genitive = period.endsWith('s') ? period : '${period}s';
      return '$genitive gratis prov';
    }
    return intro;
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
