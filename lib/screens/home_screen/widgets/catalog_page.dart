import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/catalog/catalog_models.dart';
import '../../../theme.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _scrollController = ScrollController();
  final _scrollViewKey = GlobalKey();
  final _groupKeys = List.generate(catalogGroups.length, (_) => GlobalKey());
  var _selectedGroupIndex = 0;
  var _scrollingToGroup = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_syncSelectedGroup);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_syncSelectedGroup)
      ..dispose();
    super.dispose();
  }

  Future<void> _showFilters(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const _CatalogFiltersDialog(),
    );
  }

  Future<void> _scrollToGroup(int index) async {
    final groupRenderObject = _groupKeys[index].currentContext
        ?.findRenderObject();
    final scrollRenderObject = _scrollViewKey.currentContext
        ?.findRenderObject();

    if (groupRenderObject is! RenderBox ||
        scrollRenderObject is! RenderBox ||
        !_scrollController.hasClients) {
      return;
    }

    final groupTop = groupRenderObject.localToGlobal(Offset.zero).dy;
    final scrollTop = scrollRenderObject.localToGlobal(Offset.zero).dy;
    final targetOffset = (_scrollController.offset + groupTop - scrollTop)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    setState(() => _selectedGroupIndex = index);
    _scrollingToGroup = true;
    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
    _scrollingToGroup = false;
    _syncSelectedGroup();
  }

  void _syncSelectedGroup() {
    if (_scrollingToGroup || !_scrollController.hasClients) {
      return;
    }

    final scrollRenderObject = _scrollViewKey.currentContext
        ?.findRenderObject();
    if (scrollRenderObject is! RenderBox || !scrollRenderObject.attached) {
      return;
    }

    final anchor = scrollRenderObject.localToGlobal(Offset.zero).dy + 8;
    var currentIndex = 0;
    var closestDistance = double.infinity;

    for (var index = 0; index < _groupKeys.length; index++) {
      final renderObject = _groupKeys[index].currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) {
        continue;
      }

      final top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= anchor) {
        currentIndex = index;
        continue;
      }

      final distance = (top - anchor).abs();
      if (currentIndex == 0 && distance < closestDistance) {
        closestDistance = distance;
        currentIndex = index;
      }
    }

    if (currentIndex != _selectedGroupIndex) {
      setState(() => _selectedGroupIndex = currentIndex);
    }
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
                  'Каталог',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              IconButton(
                onPressed: () => _showFilters(context),
                tooltip: 'Фильтры',
                icon: const Icon(Icons.tune, color: SpaThemeColors.blue),
              ),
            ],
          ),
        ),
        _CatalogGroupTabs(
          selectedIndex: _selectedGroupIndex,
          onSelected: _scrollToGroup,
        ),
        Expanded(
          child: SingleChildScrollView(
            key: _scrollViewKey,
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              children: [
                for (var index = 0; index < catalogGroups.length; index++)
                  _CatalogGroupSection(
                    key: _groupKeys[index],
                    group: catalogGroups[index],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogGroupTabs extends StatelessWidget {
  const _CatalogGroupTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        key: const ValueKey('catalog_group_tabs'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
        itemCount: catalogGroups.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final group = catalogGroups[index];
          final selected = selectedIndex == index;

          return InkWell(
            key: ValueKey('catalog_group_tab_${group.id}'),
            onTap: () => onSelected(index),
            borderRadius: BorderRadius.circular(2),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 9, 2, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    group.title,
                    style: TextStyle(
                      color: selected ? SpaThemeColors.blue : Colors.grey[600],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 34 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: SpaThemeColors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CatalogGroupSection extends StatelessWidget {
  const _CatalogGroupSection({required this.group, super.key});

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
            itemCount: group.services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) =>
                _CatalogServiceCard(service: group.services[index]),
          ),
        ],
      ),
    );
  }
}

class _CatalogServiceCard extends StatelessWidget {
  const _CatalogServiceCard({required this.service});

  final CatalogService service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F6F6),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ServiceTitle(service: service),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  service.description,
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
                      service.duration,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${service.price} ₽',
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

class _ServiceTitle extends StatelessWidget {
  const _ServiceTitle({required this.service});

  final CatalogService service;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: SpaThemeColors.blue,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );

    if (service.badge == null) {
      return Text(
        service.title,
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
          TextSpan(text: service.title, style: titleStyle),
        ],
      ),
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
