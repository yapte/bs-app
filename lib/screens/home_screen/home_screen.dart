import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api.dart';
import 'bloc/chat_bloc.dart';
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
    final api = ApiScope.of(context);
    final wsService = ApiScope.chatWsServiceOf(context);

    return BlocProvider(
      create: (context) => ChatBloc(api: api, wsService: wsService)
        ..add(
          ChatStarted(
            draftProcedureId: widget.draftProcedureId,
            isVisible: _selectedIndex == 3,
          ),
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _selectedIndex = index);
                  context.read<ChatBloc>().add(
                    ChatVisibilityChanged(index == 3),
                  );
                },
                children: const [
                  ProfilePage(),
                  ClientSchedulePage(),
                  CatalogPage(),
                  ChatPage(),
                ],
              ),
            ),
            bottomNavigationBar: BlocSelector<ChatBloc, ChatState, int>(
              selector: (state) => state.unreadCount,
              builder: (context, unreadCount) {
                return HomeNavigationBar(
                  selectedIndex: _selectedIndex,
                  chatUnreadCount: unreadCount,
                  onDestinationSelected: (index) {
                    context.read<ChatBloc>().add(
                      ChatVisibilityChanged(index == 3),
                    );
                    _selectPage(index);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
