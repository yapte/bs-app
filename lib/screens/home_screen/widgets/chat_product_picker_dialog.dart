import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/catalog/catalog_models.dart';
import '../../../theme.dart';

class ProductPickerDialog extends StatefulWidget {
  const ProductPickerDialog({super.key});

  @override
  State<ProductPickerDialog> createState() => _ProductPickerDialogState();
}

class _ProductPickerDialogState extends State<ProductPickerDialog> {
  final _searchController = TextEditingController();

  List<ProductSelection> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    final products = [
      for (final group in catalogGroups)
        for (final product in group.products)
          ProductSelection(group: group, product: product),
    ];

    if (query.isEmpty) {
      return products;
    }

    return products.where((entry) {
      return entry.product.title.toLowerCase().contains(query) ||
          entry.product.description.toLowerCase().contains(query) ||
          entry.group.title.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выбор процедуры'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Поиск по процедурам',
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = products[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        entry.product.title,
                        style: const TextStyle(
                          color: SpaThemeColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${entry.group.title} · '
                        '${entry.product.duration} · '
                        '${entry.product.price} ₽',
                      ),
                      onTap: () => Navigator.of(context).pop(entry),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSelection {
  const ProductSelection({required this.group, required this.product});

  final CatalogGroup group;
  final Product product;
}
