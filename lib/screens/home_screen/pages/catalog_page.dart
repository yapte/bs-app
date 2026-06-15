import 'package:flutter/material.dart';

import '../../../data/catalog/catalog_mock_data.dart';
import '../../../theme.dart';
import '../widgets/catalog_filters_dialog.dart';
import '../widgets/catalog_group_section.dart';

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
      builder: (context) => const CatalogFiltersDialog(),
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
                  CatalogGroupSection(
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
