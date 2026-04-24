import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/monthly_guides.dart';
import '../models/monthly_guide.dart';
import '../services/affiliate_service.dart';
import '../utils/constants.dart';
import '../widgets/affiliate_card.dart';

class MonthlyGuideScreen extends StatefulWidget {
  final int? initialMonth;

  const MonthlyGuideScreen({super.key, this.initialMonth});

  @override
  State<MonthlyGuideScreen> createState() => _MonthlyGuideScreenState();
}

class _MonthlyGuideScreenState extends State<MonthlyGuideScreen> {
  late int _month;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth ?? DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    final guide = MonthlyGuides.forMonth(_month);
    return Scaffold(
      appBar: AppBar(
        title: Text('Månadens guide – ${AppConstants.monthNamesSv[_month]}'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _monthSelector(),
          _header(guide),
          ...guide.sections.map(_sectionCard),
          if (guide.chores.isNotEmpty) _choresCard(guide.chores),
          const SizedBox(height: 12),
          AffiliateCard(
            title: 'Månadens produkter',
            products: AffiliateService.productsForMonth(_month),
          ),
        ],
      ),
    );
  }

  Widget _monthSelector() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 12,
        separatorBuilder: (ctx, i) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final m = i + 1;
          final selected = m == _month;
          return ChoiceChip(
            label: Text(AppConstants.monthNamesSv[m]),
            selected: selected,
            onSelected: (_) => setState(() => _month = m),
          );
        },
      ),
    );
  }

  Widget _header(MonthlyGuide guide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(guide.headline,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(guide.intro, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  Widget _sectionCard(GuideSection section) {
    final products = AffiliateService.productsForBundle(section.affiliateBundle);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(section.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(section.title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(section.intro,
                style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: section.bullets
                  .map((b) => Chip(
                        label: Text(b),
                        backgroundColor: Colors.green.shade50,
                        side: BorderSide(color: Colors.green.shade100),
                      ))
                  .toList(),
            ),
            if (section.tip != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(section.tip!,
                          style: const TextStyle(fontSize: 13, height: 1.4)),
                    ),
                  ],
                ),
              ),
            ],
            if (products.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 6),
              Text('Rekommenderat för ${section.title.toLowerCase()}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700)),
              const SizedBox(height: 4),
              ...products.take(4).map((p) => _productRow(p)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _productRow(AffiliateProduct p) {
    return InkWell(
      onTap: () => _openAmazon(p.query),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(p.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(child: Text(p.name, style: const TextStyle(fontSize: 13))),
            const Icon(Icons.open_in_new, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _choresCard(List<String> chores) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.checklist, color: Color(0xFF2D5016)),
                SizedBox(width: 8),
                Text('Trädgårdssysslor',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            ...chores.map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 18, color: Color(0xFF7CB342)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(c,
                              style: const TextStyle(fontSize: 14, height: 1.3))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _openAmazon(String query) async {
    final uri = Uri.parse(AffiliateService.urlFor(query));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
