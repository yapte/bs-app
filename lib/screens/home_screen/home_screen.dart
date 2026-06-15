import 'package:flutter/material.dart';

import 'pages/catalog_page.dart';
import 'pages/chat_page.dart';
import 'pages/client_schedule_page.dart';
import 'pages/profile_page.dart';
import 'widgets/home_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  var _selectedIndex = 0;

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
          children: const [
            ProfilePage(),
            ClientSchedulePage(),
            CatalogPage(),
            ChatPage(),
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
