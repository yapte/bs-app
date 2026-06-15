import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  Future<void> _showFilters(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const _CatalogFiltersDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              IconButton(
                onPressed: () => _showFilters(context),
                tooltip: '\u0424\u0438\u043B\u044C\u0442\u0440\u044B',
                icon: const Icon(Icons.tune, color: SpaThemeColors.blue),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogFiltersDialog extends StatefulWidget {
  const _CatalogFiltersDialog();

  @override
  State<_CatalogFiltersDialog> createState() => _CatalogFiltersDialogState();
}

class _CatalogFiltersDialogState extends State<_CatalogFiltersDialog> {
  final _priceFromController = TextEditingController();
  final _priceToController = TextEditingController();
  final _selectedCategories = <String>{'\u041C\u0430\u0441\u0441\u0430\u0436'};
  var _availableToday = true;

  static const _categories = [
    '\u041C\u0430\u0441\u0441\u0430\u0436',
    '\u0413\u0438\u0434\u0440\u043E\u0442\u0435\u0440\u0430'
        '\u043F\u0438\u044F',
    '\u0423\u0445\u043E\u0434 \u0437\u0430 '
        '\u043B\u0438\u0446\u043E\u043C',
    '\u0411\u0430\u043D\u043D\u044B\u0439 '
        '\u043A\u043E\u043C\u043F\u043B\u0435\u043A\u0441',
    '\u0410\u044E\u0440\u0432\u0435\u0434\u0430',
  ];

  @override
  void dispose() {
    _priceFromController.dispose();
    _priceToController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category, bool? selected) {
    setState(() {
      if (selected ?? false) {
        _selectedCategories.add(category);
      } else {
        _selectedCategories.remove(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('\u0424\u0438\u043B\u044C\u0442\u0440\u044B'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              '\u0426\u0435\u043D\u0430',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PriceField(
                    controller: _priceFromController,
                    label: '\u041E\u0422',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PriceField(
                    controller: _priceToController,
                    label: '\u0414\u041E',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              '\u041A\u0430\u0442\u0435\u0433\u043E\u0440\u0438\u0438',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final category in _categories)
              CheckboxListTile(
                value: _selectedCategories.contains(category),
                onChanged: (selected) => _toggleCategory(category, selected),
                title: Text(category),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _availableToday,
              onChanged: (value) => setState(() => _availableToday = value),
              title: const Text(
                '\u0414\u043E\u0441\u0442\u0443\u043F\u043D\u044B '
                '\u0441\u0435\u0433\u043E\u0434\u043D\u044F',
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '\u041F\u0440\u0438\u043C\u0435\u043D\u0438\u0442\u044C',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PositiveIntegerFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.currency_ruble),
      ),
    );
  }
}

class _PositiveIntegerFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text);
    if (value == null || value <= 0) {
      return oldValue;
    }

    return newValue;
  }
}
