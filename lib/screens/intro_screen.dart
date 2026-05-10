import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/ui_settings_service.dart';

/// Three-step features intro shown once after the user picks their
/// zone. Builds enough mental model that the bookmark-vs-plus action
/// on PlantCard, the season planner, and the morning notifications all
/// feel intentional rather than mysterious.
///
/// Skippable from any step — no one reads three screens of marketing.
class IntroScreen extends StatefulWidget {
  final VoidCallback onDone;
  const IntroScreen({super.key, required this.onDone});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _controller = PageController();
  int _page = 0;

  List<_Page> _buildPages(AppLocalizations l10n) => [
        _Page(
          emoji: '➕',
          title: l10n.introPage1Title,
          body: l10n.introPage1Body,
          hint: l10n.introPage1Hint,
        ),
        _Page(
          emoji: '🔖',
          title: l10n.introPage2Title,
          body: l10n.introPage2Body,
          hint: l10n.introPage2Hint,
        ),
        _Page(
          emoji: '🌟',
          title: l10n.introPage3Title,
          body: l10n.introPage3Body,
          hint: l10n.introPage3Hint,
        ),
      ];

  Future<void> _finish() async {
    await context.read<UISettingsService>().setIntroShown(true);
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _buildPages(l10n);
    final isLast = _page == pages.length - 1;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.introSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: pages.length,
                itemBuilder: (_, i) => _PageView(page: pages[i]),
              ),
            ),
            // Page indicator + actions.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page
                              ? const Color(0xFF558B2F)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF558B2F),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (isLast) {
                          _finish();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: Text(
                        isLast ? l10n.introStart : l10n.introNext,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page {
  final String emoji;
  final String title;
  final String body;
  final String hint;
  const _Page({
    required this.emoji,
    required this.title,
    required this.body,
    required this.hint,
  });
}

class _PageView extends StatelessWidget {
  final _Page page;
  const _PageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6E5),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: const Color(0xFFCDE0AB),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                page.emoji,
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF4A5240),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE8D26A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    page.hint,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF5A3B00),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
