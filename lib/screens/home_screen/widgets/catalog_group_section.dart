import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_models.dart';
import '../../../theme.dart';
import '../../product_details_screen/product_details_screen.dart';

class CatalogGroupSection extends StatelessWidget {
  const CatalogGroupSection({required this.group, super.key});

  final CatalogGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            group.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) =>
                _ProductCard(group: group, product: group.products[index]),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.group, required this.product});

  final CatalogGroup group;
  final Product product;

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ProductDetailsScreen(group: group, product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F6F6),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductTitle(product: product),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  product.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.45,
                  ),
                ),
              ),
              const Divider(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.duration,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${product.price} ₽',
                    style: const TextStyle(
                      color: Color(0xFFB4930B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: SpaThemeColors.blue,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );

    if (product.badge == null) {
      return Text(
        product.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      );
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.only(right: 6, bottom: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF58B431),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'НОВИНКА',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          TextSpan(text: product.title, style: titleStyle),
        ],
      ),
    );
  }
}
