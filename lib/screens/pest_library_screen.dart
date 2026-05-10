import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/pest_entry.dart';
import '../services/pest_library_service.dart';

/// Searchable reference of common Swedish garden pests, diseases, and
/// damage. Each entry has symptoms (so the user can match what they
/// see), mild + strong action options, and prevention tips.
///
/// Three intentional design choices:
///   1. *Action ladder* — start with milt (low-risk, may not work), end
///      with starkt (effective but more invasive). Most app pest
///      guides only show one option, which often turns out wrong for
///      the gardener's situation.
///   2. *Symptom-led* — the user usually opens this when they SEE
///      something. Symptoms come first in each card, name second.
///   3. *Prevention always shown* — even after damage is done, next
///      season is right around the corner.
class PestLibraryScreen extends StatefulWidget {
  const PestLibraryScreen({super.key});

  @override
  State<PestLibraryScreen> createState() => _PestLibraryScreenState();
}

class _PestLibraryScreenState extends State<PestLibraryScreen> {
  String _query = '';
  String? _typeFilter; // null = all
  final _ctl = TextEditingController();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      appBar: AppBar(
        title: Text(l10n.pestLibraryTitle),
        backgroundColor: const Color(0xFFFAF8F1),
        elevation: 0,
      ),
      body: Consumer<PestLibraryService>(
        builder: (ctx, lib, _) {
          if (!lib.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = lib
              .search(_query)
              .where((e) => _typeFilter == null || e.type == _typeFilter)
              .toList();

          return Column(
            children: [
              _Search(
                ctl: _ctl,
                onChanged: (v) => setState(() => _query = v),
                typeFilter: _typeFilter,
                onTypeChanged: (t) => setState(() => _typeFilter = t),
                count: results.length,
              ),
              if (results.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text(
                            l10n.pestLibraryNoMatch,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount: results.length,
                    itemBuilder: (_, i) => _PestCard(entry: results[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Search extends StatelessWidget {
  final TextEditingController ctl;
  final ValueChanged<String> onChanged;
  final String? typeFilter;
  final ValueChanged<String?> onTypeChanged;
  final int count;
  const _Search({
    required this.ctl,
    required this.onChanged,
    required this.typeFilter,
    required this.onTypeChanged,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: ctl,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: l10n.pestLibrarySearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ctl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ctl.clear();
                        onChanged('');
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _Chip(
                  label: l10n.myGardenFilterAll,
                  selected: typeFilter == null,
                  onTap: () => onTypeChanged(null),
                ),
                _Chip(
                  label: l10n.pestLibraryFilterPests,
                  selected: typeFilter == 'skadedjur',
                  onTap: () =>
                      onTypeChanged(typeFilter == 'skadedjur' ? null : 'skadedjur'),
                ),
                _Chip(
                  label: l10n.pestLibraryFilterDiseases,
                  selected: typeFilter == 'sjukdom',
                  onTap: () =>
                      onTypeChanged(typeFilter == 'sjukdom' ? null : 'sjukdom'),
                ),
                _Chip(
                  label: l10n.pestLibraryFilterDamage,
                  selected: typeFilter == 'skada',
                  onTap: () =>
                      onTypeChanged(typeFilter == 'skada' ? null : 'skada'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF2D5016),
        ),
        selectedColor: const Color(0xFF558B2F),
        backgroundColor: Colors.white,
        side: BorderSide(
          color:
              selected ? const Color(0xFF558B2F) : const Color(0xFFCDE0AB),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _PestCard extends StatefulWidget {
  final PestEntry entry;
  const _PestCard({required this.entry});

  @override
  State<_PestCard> createState() => _PestCardState();
}

class _PestCardState extends State<_PestCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final typeColor = _typeColor(e.type);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEDEDE2)),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(e.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2A1A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _typeLabel(context, e.type),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: typeColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  e.symptoms,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1F2A1A),
                    height: 1.4,
                  ),
                ),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  if (e.affects.isNotEmpty) ...[
                    _Row(
                        label: AppLocalizations.of(context).pestAffects,
                        body: e.affects.join(', ')),
                    const SizedBox(height: 8),
                  ],
                  _Section(
                    title: AppLocalizations.of(context).pestSectionMild,
                    body: e.mildAction,
                    color: const Color(0xFF558B2F),
                  ),
                  const SizedBox(height: 6),
                  _Section(
                    title: AppLocalizations.of(context).pestSectionStrong,
                    body: e.strongAction,
                    color: const Color(0xFFE65100),
                  ),
                  const SizedBox(height: 6),
                  _Section(
                    title: AppLocalizations.of(context).pestSectionPrevent,
                    body: e.prevention,
                    color: const Color(0xFF1976D2),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _typeColor(String t) => switch (t) {
        'sjukdom' => const Color(0xFFE65100),
        'skada' => const Color(0xFF1976D2),
        _ => const Color(0xFF558B2F),
      };

  String _typeLabel(BuildContext context, String t) {
    final l10n = AppLocalizations.of(context);
    return switch (t) {
      'sjukdom' => l10n.pestTypeLabelDisease,
      'skada' => l10n.pestTypeLabelDamage,
      _ => l10n.pestTypeLabelPest,
    };
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String body;
  const _Row({required this.label, required this.body});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12.5,
          color: Color(0xFF1F2A1A),
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  final Color color;
  const _Section({
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (body.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: Color(0xFF1F2A1A),
            ),
          ),
        ],
      ),
    );
  }
}
