import 'package:flutter/material.dart';

import 'pages/catalog_page.dart';
import 'pages/chat_page.dart';
import 'pages/client_schedule_page.dart';
import 'pages/profile_page.dart';
import 'widgets/home_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialTab, this.draftProcedureId});

  final String? initialTab;
  final String? draftProcedureId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _controller;
  late int _selectedIndex;

  int get _initialIndex {
    return switch (widget.initialTab) {
      'schedule' => 1,
      'catalog' => 2,
      'chat' => 3,
      _ => 0,
    };
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = _initialIndex;
    _controller = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() {
            _selectedIndex = index;
          }),
          children: [
            const ProfilePage(),
            const ClientSchedulePage(),
            const CatalogPage(),
            ChatPage(draftProcedureId: widget.draftProcedureId),
          ],
        ),
      ),
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectPage,
      ),
    );
  }
}
