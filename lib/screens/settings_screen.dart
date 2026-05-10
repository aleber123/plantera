import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/backup_service.dart';
import '../services/garden_service.dart';
import '../services/harvest_service.dart';
import '../services/notification_service.dart';
import '../services/premium_service.dart';
import '../services/season_planner_service.dart';
import '../services/ui_settings_service.dart';
import '../utils/constants.dart';
import '../widgets/affiliate_card.dart';
import '../services/affiliate_service.dart';
import 'gardens_screen.dart';
import 'intro_screen.dart';
import 'paywall_screen.dart';
import 'pest_library_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final premium = context.watch<PremiumService>();
    final notifications = context.watch<NotificationService>();
    final ui = context.watch<UISettingsService>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(premium.isPremium
                ? l10n.settingsPremiumActive
                : l10n.settingsPremiumUpgrade),
            subtitle: Text(premium.isPremium
                ? _planLabel(l10n, premium.currentPlan)
                : l10n.settingsPremiumUnlock),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PaywallScreen()),
            ),
          ),
          const Divider(),
          Consumer<GardenService>(
            builder: (ctx, garden, _) {
              final n = garden.gardens.length;
              return ListTile(
                leading: const Icon(Icons.yard_outlined),
                title: Text(n == 1
                    ? l10n.settingsMyGardens
                    : l10n.settingsMyGardensWithCount(n.toString())),
                subtitle: Text(garden.activeGarden != null
                    ? l10n.settingsMyGardensSubtitle(
                        garden.activeGarden!.emoji,
                        garden.activeGarden!.name)
                    : l10n.settingsMyGardensEmpty),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GardensScreen()),
                ),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: Text(l10n.settingsNotifications),
            subtitle: Text(l10n.settingsNotificationsBody),
            value: notifications.enabled,
            onChanged: (v) async {
              await notifications.setEnabled(v);
              if (v) await notifications.requestPermissions();
            },
          ),
          if (notifications.enabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(l10n.settingsMorningHour),
              subtitle: Text(l10n.settingsMorningHourBody(
                  notifications.morningHour.toString().padLeft(2, '0'))),
              trailing: const Icon(Icons.edit),
              onTap: () => _pickMorningHour(context, notifications),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.text_fields),
            title: Text(l10n.settingsLargeText),
            subtitle: Text(l10n.settingsLargeTextBody),
            value: ui.largeText,
            onChanged: ui.setLargeText,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.tune),
            title: Text(l10n.settingsSimpleStatus),
            subtitle: Text(l10n.settingsSimpleStatusBody),
            value: ui.simpleStatus,
            onChanged: ui.setSimpleStatus,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: Text(l10n.settingsPestLibrary),
            subtitle: Text(l10n.settingsPestLibraryBody),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PestLibraryScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.tips_and_updates_outlined),
            title: Text(l10n.settingsIntro),
            subtitle: Text(l10n.settingsIntroBody),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => IntroScreen(
                  onDone: () => Navigator.of(ctx).pop(),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(l10n.settingsBackup),
            subtitle: Text(l10n.settingsBackupBody),
            trailing: const Icon(Icons.share),
            onTap: () => _exportBackup(context),
          ),
          const Divider(),
          AffiliateCard(
            title: l10n.settingsStarterKit,
            products: AffiliateService.starterProducts(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(l10n.settingsRestorePurchases),
            onTap: () => premium.restorePurchases(),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(l10n.settingsPrivacyPolicy),
            onTap: () => _open(AppConstants.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.settingsTerms),
            onTap: () => _open(AppConstants.termsOfUseUrl),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.settingsSupport),
            onTap: () => _open(AppConstants.supportUrl),
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: Text(l10n.settingsFeedback),
            subtitle: Text(l10n.settingsFeedbackBody),
            onTap: () => _sendFeedback(l10n),
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

  String _planLabel(AppLocalizations l10n, PremiumPlan p) => switch (p) {
        PremiumPlan.monthly => l10n.settingsPlanMonthly,
        PremiumPlan.yearly => l10n.settingsPlanYearly,
        PremiumPlan.lifetime => l10n.settingsPlanLifetime,
        PremiumPlan.free => l10n.settingsPlanFree,
      };

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendFeedback(AppLocalizations l10n) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      queryParameters: {
        'subject': l10n.settingsFeedbackSubject,
        'body': l10n.settingsFeedbackBodyTemplate(AppConstants.appVersion),
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _pickMorningHour(
      BuildContext context, NotificationService notifications) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.settingsMorningHourPickerTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.settingsMorningHourPickerBody,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 14),
              for (final h in const [6, 7, 8, 9, 10, 11])
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: InkWell(
                    onTap: () => Navigator.of(ctx).pop(h),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: notifications.morningHour == h
                            ? const Color(0xFFEFF6E5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: notifications.morningHour == h
                              ? const Color(0xFF558B2F)
                              : const Color(0xFFE6E6DC),
                          width: notifications.morningHour == h ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                              l10n.settingsHourFormat(
                                  h.toString().padLeft(2, '0')),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                          if (notifications.morningHour == h)
                            const Icon(Icons.check_circle,
                                color: Color(0xFF558B2F)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return;
    await notifications.setMorningHour(picked);
  }

  Future<void> _exportBackup(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final garden = context.read<GardenService>();
    final harvest = context.read<HarvestService>();
    final season = context.read<SeasonPlannerService>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await BackupService().exportToShare(
        garden: garden,
        harvest: harvest,
        season: season,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupFailed(e.toString()))),
      );
    }
  }
}
