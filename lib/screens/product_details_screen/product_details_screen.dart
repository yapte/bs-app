import 'package:flutter/material.dart';

import '../../data/catalog/catalog_models.dart';
import 'widgets/product_details_features.dart';
import 'widgets/product_details_info.dart';
import 'widgets/product_details_slider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    required this.group,
    required this.product,
    super.key,
  });

  final CatalogGroup group;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          const ProductDetailsSlider(),
          ProductDetailsInfo(group: group, product: product),
          const ProductDetailsFeatures(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('ОБСУДИТЬ С АДМИНИСТРАТОРОМ'),
            ),
          ),
        ],
      ),
    );
  }
}
