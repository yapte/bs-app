import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatalogFiltersDialog extends StatefulWidget {
  const CatalogFiltersDialog({super.key});

  @override
  State<CatalogFiltersDialog> createState() => _CatalogFiltersDialogState();
}

class _CatalogFiltersDialogState extends State<CatalogFiltersDialog> {
  final _priceFromController = TextEditingController();
  final _priceToController = TextEditingController();
  final _selectedCategories = <String>{'Массаж'};
  var _availableToday = true;

  static const _categories = [
    'Массаж',
    'Гидротерапия',
    'Уход за лицом',
    'Банный комплекс',
    'Аюрведа',
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
          title: const Text('Фильтры'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('Цена', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PriceField(
                    controller: _priceFromController,
                    label: 'ОТ',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PriceField(
                    controller: _priceToController,
                    label: 'ДО',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Категории', style: Theme.of(context).textTheme.titleLarge),
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
              title: const Text('Доступны сегодня'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Применить'),
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
