import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/affiliate_service.dart';

class AffiliateCard extends StatelessWidget {
  final String title;
  final List<AffiliateProduct> products;
  final String footnote;

  const AffiliateCard({
    super.key,
    required this.title,
    required this.products,
    this.footnote =
        'Annonslänkar – vi kan få provision om du handlar via Amazon.',
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: Color(0xFF2D5016)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...products.map((p) => _row(context, p)),
            const SizedBox(height: 8),
            Text(footnote,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext ctx, AffiliateProduct p) {
    return InkWell(
      onTap: () => _open(AffiliateService.urlFor(p.query)),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(p.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(p.name,
                  style: const TextStyle(fontSize: 14)),
            ),
            const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
