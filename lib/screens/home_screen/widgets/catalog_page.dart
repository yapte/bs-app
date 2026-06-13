import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
