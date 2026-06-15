import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../../data/chat/mock_spa_chat_service.dart';
import '../../../theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final MockSpaChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = MockSpaChatService();
  }

  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
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
                  'Чат',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: _OnlineBadge(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Chat(
            chatController: _chatService.chatController,
            currentUserId: MockSpaChatService.clientId,
            onMessageSend: _chatService.sendClientMessage,
            resolveUser: (UserID id) => _chatService.resolveUser(id),
            backgroundColor: SpaThemeColors.paper,
          ),
        ),
      ],
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SpaThemeColors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Администратор онлайн',
          style: TextStyle(
            color: SpaThemeColors.blueDark,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
