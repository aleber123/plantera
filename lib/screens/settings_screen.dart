import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/notification_service.dart';
import '../services/premium_service.dart';
import '../services/zone_service.dart';
import '../utils/constants.dart';
import '../utils/swedish_zones.dart';
import '../widgets/affiliate_card.dart';
import '../services/affiliate_service.dart';
import 'paywall_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zone = context.watch<ZoneService>();
    final premium = context.watch<PremiumService>();
    final notifications = context.watch<NotificationService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Inställningar')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(premium.isPremium
                ? 'Premium aktivt'
                : 'Uppgradera till Premium'),
            subtitle: Text(premium.isPremium
                ? _planLabel(premium.currentPlan)
                : 'Lås upp alla funktioner'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PaywallScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.place),
            title: Text('Plats: ${zone.city ?? "Ingen vald"}'),
            subtitle: Text('Zon ${zone.zone} – ${zone.zoneDescription}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _pickZone(context),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Påminnelser'),
            subtitle: const Text('Frostvarningar och planteringstider'),
            value: notifications.enabled,
            onChanged: (v) async {
              await notifications.setEnabled(v);
              if (v) await notifications.requestPermissions();
            },
          ),
          const Divider(),
          AffiliateCard(
            title: '🛒 Nybörjarkit',
            products: AffiliateService.starterProducts(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Återställ köp'),
            onTap: () => premium.restorePurchases(),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Integritetspolicy'),
            onTap: () => _open(AppConstants.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Användarvillkor (EULA)'),
            onTap: () => _open(AppConstants.termsOfUseUrl),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Support'),
            onTap: () => _open(AppConstants.supportUrl),
          ),
          if (kDebugMode) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.orange),
              title: const Text('DEBUG: Aktivera premium (30 d)'),
              onTap: () async {
                await premium.grantTemporaryPremium(
                    duration: const Duration(days: 30));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Premium aktiverat i 30 dagar')),
                  );
                }
              },
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  String _planLabel(PremiumPlan p) => switch (p) {
        PremiumPlan.monthly => 'Månadsprenumeration',
        PremiumPlan.yearly => 'Årsprenumeration',
        PremiumPlan.lifetime => 'Livstidsköp',
        PremiumPlan.free => 'Gratis',
      };

  Future<void> _pickZone(BuildContext context) async {
    final cities = SwedishZones.cityCoords.keys.toList()..sort();
    final sel = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => ListView(
        children: cities
            .map((c) => ListTile(
                  title: Text(c),
                  onTap: () => Navigator.pop(ctx, c),
                ))
            .toList(),
      ),
    );
    if (sel != null && context.mounted) {
      await context.read<ZoneService>().setCity(sel);
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
