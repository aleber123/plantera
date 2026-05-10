import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/harvest_entry.dart';
import '../models/plant.dart';
import '../services/harvest_service.dart';
import '../utils/harvest_value.dart';

/// Inline harvest log on the plant detail screen. Lists entries for the
/// current gardenPlant + per-unit total + a small "Logga skörd" button.
/// When a [Plant] is supplied we also compute and surface an estimated
/// SEK value for the running total — gives the gardener a tangible
/// number without needing them to open the stats screen.
class HarvestSection extends StatelessWidget {
  final String gardenPlantId;
  final String plantName;
  final Plant? plant;
  const HarvestSection({
    super.key,
    required this.gardenPlantId,
    required this.plantName,
    this.plant,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<HarvestService>(
      builder: (ctx, harvest, _) {
        final entries = harvest.forPlant(gardenPlantId)
          ..sort((a, b) => b.date.compareTo(a.date));
        final totals = harvest.totalsForPlant(gardenPlantId);
        double estimatedSek = 0;
        if (plant != null) {
          for (final e in entries) {
            estimatedSek += HarvestValue.estimateSek(plant!, e.unit, e.amount);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.harvestSectionTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showAddSheet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.harvestLog),
                ),
              ],
            ),
            if (totals.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...totals.entries.map((e) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6E5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCDE0AB)),
                      ),
                      child: Text(
                        l10n.harvestTotalLabel(_fmtAmount(e.value), e.key.label),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D5016),
                        ),
                      ),
                    );
                  }),
                  if (estimatedSek > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFE8D26A)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💰',
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            l10n.harvestEstimatedSek(
                                estimatedSek.round().toString()),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A4F00),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.harvestEmpty,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              for (final e in entries.take(8))
                _entryRow(context, e),
              if (entries.length > 8)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.harvestMoreEntries(
                        (entries.length - 8).toString()),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  Widget _entryRow(BuildContext context, HarvestEntry e) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              DateFormat('d MMM', localeName).format(e.date),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              '${_fmtAmount(e.amount)} ${e.unit.label}'
              '${e.notes != null && e.notes!.isNotEmpty ? ' • ${e.notes}' : ''}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline, color: Colors.black38),
            onPressed: () => _confirmDelete(context, e),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, HarvestEntry e) async {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.harvestRemoveTitle),
        content: Text(l10n.harvestRemoveBody(
          _fmtAmount(e.amount),
          e.unit.label,
          DateFormat('d MMM y', localeName).format(e.date),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonDelete,
                style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<HarvestService>().remove(e.id);
  }

  Future<void> _showAddSheet(BuildContext context) async {
    final result = await showModalBottomSheet<_AddResult>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddHarvestSheet(plantName: plantName),
    );
    if (result == null || !context.mounted) return;
    // Medium impact = "something good happened" — logging a harvest is
    // the celebration moment of the whole app, deserves the bigger
    // physical confirmation than a passive watering tap.
    HapticFeedback.mediumImpact();
    await context.read<HarvestService>().add(
          gardenPlantId: gardenPlantId,
          date: result.date,
          amount: result.amount,
          unit: result.unit,
          notes: result.notes,
        );
  }

  static String _fmtAmount(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(
        RegExp(r'\.$'), '');
  }
}

class _AddResult {
  final DateTime date;
  final double amount;
  final HarvestUnit unit;
  final String? notes;
  const _AddResult(this.date, this.amount, this.unit, this.notes);
}

class _AddHarvestSheet extends StatefulWidget {
  final String plantName;
  const _AddHarvestSheet({required this.plantName});

  @override
  State<_AddHarvestSheet> createState() => _AddHarvestSheetState();
}

class _AddHarvestSheetState extends State<_AddHarvestSheet> {
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  HarvestUnit _unit = HarvestUnit.kg;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.harvestAddTitle(widget.plantName),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _amountCtrl,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.harvestAmountLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<HarvestUnit>(
                  initialValue: _unit,
                  decoration: InputDecoration(
                    labelText: l10n.harvestUnitLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: HarvestUnit.values
                      .map((u) =>
                          DropdownMenuItem(value: u, child: Text(u.label)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _unit = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(DateFormat('d MMM y', localeName).format(_date)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            decoration: InputDecoration(
              labelText: l10n.harvestNotesLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final raw = _amountCtrl.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0 || amount.isNaN || amount.isInfinite) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.harvestErrorAmountTooLow)),
      );
      return;
    }
    // Block future dates — DatePicker's lastDate isn't always honored
    // (e.g. if the user fiddles with system clock).
    if (_date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.harvestErrorFutureDate)),
      );
      return;
    }
    final notes = _notesCtrl.text.trim();
    Navigator.of(context).pop(_AddResult(
      _date,
      amount,
      _unit,
      notes.isEmpty ? null : notes,
    ));
  }
}
