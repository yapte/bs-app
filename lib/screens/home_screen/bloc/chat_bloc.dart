import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/api.dart';
import '../../../common/models/models.dart';

sealed class ChatEvent {
  const ChatEvent();
}

final class ChatStarted extends ChatEvent {
  const ChatStarted({this.draftProcedureId, this.isVisible = false});

  final String? draftProcedureId;
  final bool isVisible;
}

final class ChatRetried extends ChatEvent {
  const ChatRetried();
}

final class ChatVisibilityChanged extends ChatEvent {
  const ChatVisibilityChanged(this.isVisible);

  final bool isVisible;
}

final class ChatMessageSubmitted extends ChatEvent {
  const ChatMessageSubmitted(this.text);

  final String text;
}

final class ChatImageSelected extends ChatEvent {
  const ChatImageSelected(this.filePath);

  final String filePath;
}

final class ChatProcedureSelected extends ChatEvent {
  const ChatProcedureSelected(this.procedure);

  final SpaProcedure procedure;
}

final class ChatFavoriteGroupSelected extends ChatEvent {
  const ChatFavoriteGroupSelected(this.group);

  final ApiFavoriteGroup group;
}

final class ChatDraftAttachmentRemoved extends ChatEvent {
  const ChatDraftAttachmentRemoved(this.attachment);

  final SpaChatAttachment attachment;
}

final class _ChatWsMessageCreated extends ChatEvent {
  const _ChatWsMessageCreated(this.event);

  final ChatWsMessageCreatedEvent event;
}

final class _ChatWsMessageDeleted extends ChatEvent {
  const _ChatWsMessageDeleted(this.event);

  final ChatWsMessageDeletedEvent event;
}

final class _ChatWsReadUpdated extends ChatEvent {
  const _ChatWsReadUpdated(this.event);

  final ChatWsReadUpdatedEvent event;
}

final class _ChatWsChatUpdated extends ChatEvent {
  const _ChatWsChatUpdated(this.event);

  final ChatWsChatUpdatedEvent event;
}

final class _ChatWsResyncRequested extends ChatEvent {
  const _ChatWsResyncRequested();
}

final class _ChatWsStateChanged extends ChatEvent {
  const _ChatWsStateChanged(this.state);

  final ChatWsConnectionState state;
}

final class _ChatWsAuthFailed extends ChatEvent {
  const _ChatWsAuthFailed(this.error);

  final ChatWsAuthError error;
}

enum ChatStatus { initial, loading, ready, failure }

class ChatState {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.participants = const {},
    this.draftAttachments = const [],
    this.unreadCount = 0,
    this.isVisible = false,
    this.isSending = false,
    this.isUploading = false,
    this.wsState = ChatWsConnectionState.disconnected,
    this.errorMessage,
    this.currentUserId,
    this.currentUserName,
    this.chat,
  });

  final ChatStatus status;
  final List<SpaChatMessage> messages;
  final Map<String, SpaChatParticipant> participants;
  final List<SpaChatAttachment> draftAttachments;
  final int unreadCount;
  final bool isVisible;
  final bool isSending;
  final bool isUploading;
  final ChatWsConnectionState wsState;
  final String? errorMessage;
  final String? currentUserId;
  final String? currentUserName;
  final SpaChat? chat;

  ChatState copyWith({
    ChatStatus? status,
    List<SpaChatMessage>? messages,
    Map<String, SpaChatParticipant>? participants,
    List<SpaChatAttachment>? draftAttachments,
    int? unreadCount,
    bool? isVisible,
    bool? isSending,
    bool? isUploading,
    ChatWsConnectionState? wsState,
    String? errorMessage,
    bool clearError = false,
    String? currentUserId,
    String? currentUserName,
    SpaChat? chat,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      participants: participants ?? this.participants,
      draftAttachments: draftAttachments ?? this.draftAttachments,
      unreadCount: unreadCount ?? this.unreadCount,
      isVisible: isVisible ?? this.isVisible,
      isSending: isSending ?? this.isSending,
      isUploading: isUploading ?? this.isUploading,
      wsState: wsState ?? this.wsState,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserName: currentUserName ?? this.currentUserName,
      chat: chat ?? this.chat,
    );
  }
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required ApiServices api, ChatWsService? wsService})
    : _api = api,
      _wsService = wsService,
      super(
        ChatState(
          wsState: wsService == null
              ? ChatWsConnectionState.connected
              : ChatWsConnectionState.disconnected,
        ),
      ) {
    on<ChatStarted>(_onStarted);
    on<ChatRetried>(_onRetried);
    on<ChatVisibilityChanged>(_onVisibilityChanged);
    on<ChatMessageSubmitted>(_onMessageSubmitted);
    on<ChatImageSelected>(_onImageSelected);
    on<ChatProcedureSelected>(_onProcedureSelected);
    on<ChatFavoriteGroupSelected>(_onFavoriteGroupSelected);
    on<ChatDraftAttachmentRemoved>(_onDraftAttachmentRemoved);
    on<_ChatWsMessageCreated>(_onWsMessageCreated);
    on<_ChatWsMessageDeleted>(_onWsMessageDeleted);
    on<_ChatWsReadUpdated>(_onWsReadUpdated);
    on<_ChatWsChatUpdated>(_onWsChatUpdated);
    on<_ChatWsResyncRequested>(_onWsResyncRequested);
    on<_ChatWsStateChanged>(_onWsStateChanged);
    on<_ChatWsAuthFailed>(_onWsAuthFailed);
  }

  final ApiServices _api;
  final ChatWsService? _wsService;
  final _subscriptions = <StreamSubscription<Object?>>[];
  String? _draftProcedureId;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    _draftProcedureId = event.draftProcedureId;
    emit(state.copyWith(isVisible: event.isVisible));
    await _load(emit);
    _bindWebSocket();
    try {
      await _wsService?.connect();
    } catch (error) {
      emit(state.copyWith(errorMessage: _errorText(error)));
    }
  }

  Future<void> _onRetried(ChatRetried event, Emitter<ChatState> emit) async {
    await _load(emit);
    try {
      await _wsService?.reconnectWithLatestToken();
    } catch (_) {}
  }

  Future<void> _load(Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading, clearError: true));
    try {
      final profile = await _api.auth.getProfile();
      final chat = profile.role == 'guest'
          ? await _api.chats.createOrGet()
          : await _getFirstStaffChat();
      final page = await _api.chats.getMessages(chat.id, limit: 100);
      final participants = {
        for (final participant in chat.participants)
          participant.id: participant,
      };
      participants.putIfAbsent(
        profile.id.toString(),
        () => SpaChatParticipant(
          id: profile.id.toString(),
          name: profile.name,
          role: profile.role == 'guest'
              ? SpaChatParticipantRole.client
              : SpaChatParticipantRole.admin,
        ),
      );
      final drafts = List<SpaChatAttachment>.of(state.draftAttachments);
      if (_draftProcedureId != null && drafts.isEmpty) {
        final procedures = await _api.spaProcedures.getAll();
        final procedure = procedures
            .where((item) => item.slug == _draftProcedureId)
            .firstOrNull;
        if (procedure != null) {
          drafts.add(_procedureAttachment(procedure));
        }
      }
      emit(
        state.copyWith(
          status: ChatStatus.ready,
          chat: chat,
          messages: _uniqueMessages(page.items),
          participants: participants,
          draftAttachments: drafts,
          currentUserId: profile.id.toString(),
          currentUserName: profile.name,
          unreadCount: state.isVisible ? 0 : chat.unreadCount,
          clearError: true,
        ),
      );
      if (state.isVisible) {
        await _markLatestRead(emit);
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: _errorText(error),
        ),
      );
    }
  }

  Future<SpaChat> _getFirstStaffChat() async {
    final chats = await _api.chats.getAll(
      query: const PageQuery(
        sort: 'lastMessageAt',
        sortDirection: 'desc',
        itemsPerPage: 1,
      ),
      status: 'open',
    );
    if (chats.items.isEmpty) {
      throw const ApiException(
        statusCode: 404,
        code: 'CHAT_NOT_FOUND',
        message: 'Нет доступных открытых чатов',
      );
    }
    return chats.items.first;
  }

  Future<void> _onVisibilityChanged(
    ChatVisibilityChanged event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isVisible: event.isVisible));
    if (event.isVisible) {
      await _markLatestRead(emit);
    }
  }

  Future<void> _onMessageSubmitted(
    ChatMessageSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    final chat = state.chat;
    final attachments = state.draftAttachments;
    if (chat == null ||
        state.isSending ||
        (event.text.trim().isEmpty && attachments.isEmpty)) {
      return;
    }
    emit(
      state.copyWith(
        isSending: true,
        draftAttachments: const [],
        clearError: true,
      ),
    );
    try {
      final message = await _api.chats.sendMessage(
        chat.id,
        text: event.text,
        attachments: attachments,
      );
      emit(
        state.copyWith(
          isSending: false,
          messages: _appendMessage(state.messages, message),
        ),
      );
      if (state.isVisible) {
        await _markLatestRead(emit);
      }
    } catch (error) {
      emit(
        state.copyWith(
          isSending: false,
          draftAttachments: attachments,
          errorMessage: _errorText(error),
        ),
      );
    }
  }

  Future<void> _onImageSelected(
    ChatImageSelected event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isUploading) {
      return;
    }
    emit(state.copyWith(isUploading: true, clearError: true));
    try {
      final file = await _api.files.upload(event.filePath);
      emit(
        state.copyWith(
          isUploading: false,
          draftAttachments: [
            ...state.draftAttachments,
            SpaChatAttachment(
              id: 'draft-file-${file.id}',
              type: SpaChatAttachmentType.image,
              title: file.originalName,
              subtitle: file.mimeType,
              fileId: file.id,
              imageUrl: file.url,
            ),
          ],
        ),
      );
    } catch (error) {
      emit(state.copyWith(isUploading: false, errorMessage: _errorText(error)));
    }
  }

  void _onProcedureSelected(
    ChatProcedureSelected event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        draftAttachments: [
          ...state.draftAttachments,
          _procedureAttachment(event.procedure),
        ],
      ),
    );
  }

  void _onFavoriteGroupSelected(
    ChatFavoriteGroupSelected event,
    Emitter<ChatState> emit,
  ) {
    final group = event.group;
    emit(
      state.copyWith(
        draftAttachments: [
          ...state.draftAttachments,
          SpaChatAttachment(
            id: 'draft-group-${group.id}',
            type: SpaChatAttachmentType.favoriteGroup,
            title: group.title,
            subtitle: '${group.procedures.length} процедур в избранном',
            favoriteGroupId: group.id.toString(),
            favoriteGroupApiId: group.id,
          ),
        ],
      ),
    );
  }

  void _onDraftAttachmentRemoved(
    ChatDraftAttachmentRemoved event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        draftAttachments: state.draftAttachments
            .where((item) => item.id != event.attachment.id)
            .toList(),
      ),
    );
  }

  Future<void> _onWsMessageCreated(
    _ChatWsMessageCreated event,
    Emitter<ChatState> emit,
  ) async {
    final chat = state.chat;
    final message = event.event.message;
    if (chat == null || message.chatId != chat.id) {
      return;
    }
    final isNew = state.messages.every((item) => item.id != message.id);
    emit(
      state.copyWith(
        messages: _appendMessage(state.messages, message),
        unreadCount:
            isNew && !state.isVisible && message.authorId != state.currentUserId
            ? state.unreadCount + 1
            : state.unreadCount,
      ),
    );
    if (state.isVisible) {
      await _markLatestRead(emit);
    }
  }

  void _onWsMessageDeleted(
    _ChatWsMessageDeleted event,
    Emitter<ChatState> emit,
  ) {
    if (event.event.chatId != state.chat?.id) {
      return;
    }
    emit(
      state.copyWith(
        messages: state.messages
            .where((item) => item.id != event.event.messageId.toString())
            .toList(),
      ),
    );
  }

  void _onWsReadUpdated(_ChatWsReadUpdated event, Emitter<ChatState> emit) {
    if (event.event.chatId == state.chat?.id &&
        event.event.userId.toString() == state.currentUserId) {
      emit(state.copyWith(unreadCount: 0));
    }
  }

  Future<void> _onWsChatUpdated(
    _ChatWsChatUpdated event,
    Emitter<ChatState> emit,
  ) async {
    if (event.event.chatId != state.chat?.id) {
      return;
    }
    try {
      final chat = await _api.chats.getById(event.event.chatId);
      emit(
        state.copyWith(
          chat: chat,
          participants: {
            for (final participant in chat.participants)
              participant.id: participant,
          },
          unreadCount: state.isVisible ? 0 : chat.unreadCount,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onWsResyncRequested(
    _ChatWsResyncRequested event,
    Emitter<ChatState> emit,
  ) async {
    await _resync(emit);
  }

  void _onWsStateChanged(_ChatWsStateChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(wsState: event.state));
  }

  void _onWsAuthFailed(_ChatWsAuthFailed event, Emitter<ChatState> emit) {
    emit(state.copyWith(errorMessage: event.error.message));
  }

  Future<void> _resync(Emitter<ChatState> emit) async {
    final chat = state.chat;
    if (chat == null) {
      return;
    }
    final lastId = _latestMessageId(state.messages);
    try {
      final page = await _api.chats.getMessages(
        chat.id,
        limit: 100,
        afterId: lastId == 0 ? null : lastId,
      );
      final newMessages = page.items
          .where(
            (message) => state.messages.every((item) => item.id != message.id),
          )
          .toList();
      final incomingUnread = newMessages
          .where((message) => message.authorId != state.currentUserId)
          .length;
      emit(
        state.copyWith(
          messages: _uniqueMessages([...state.messages, ...newMessages]),
          unreadCount: state.isVisible ? 0 : state.unreadCount + incomingUnread,
        ),
      );
      if (state.isVisible) {
        await _markLatestRead(emit);
      }
    } catch (_) {}
  }

  Future<void> _markLatestRead(Emitter<ChatState> emit) async {
    final chat = state.chat;
    final latestId = _latestMessageId(state.messages);
    if (chat == null || latestId == 0) {
      emit(state.copyWith(unreadCount: 0));
      return;
    }
    emit(state.copyWith(unreadCount: 0));
    try {
      await _api.chats.markRead(chat.id, latestId);
    } catch (_) {}
  }

  void _bindWebSocket() {
    final ws = _wsService;
    if (ws == null || _subscriptions.isNotEmpty) {
      return;
    }
    _subscriptions.addAll([
      ws.messageCreatedEvents.listen(
        (event) => add(_ChatWsMessageCreated(event)),
      ),
      ws.messageDeletedEvents.listen(
        (event) => add(_ChatWsMessageDeleted(event)),
      ),
      ws.readUpdatedEvents.listen((event) => add(_ChatWsReadUpdated(event))),
      ws.chatUpdatedEvents.listen((event) => add(_ChatWsChatUpdated(event))),
      ws.resyncRequired.listen((_) => add(const _ChatWsResyncRequested())),
      ws.connectionStates.listen((event) => add(_ChatWsStateChanged(event))),
      ws.authErrors.listen((event) => add(_ChatWsAuthFailed(event))),
    ]);
  }

  SpaChatAttachment _procedureAttachment(SpaProcedure procedure) {
    return SpaChatAttachment(
      id: 'draft-procedure-${procedure.id}',
      type: SpaChatAttachmentType.procedure,
      title: procedure.name,
      subtitle:
          '${procedure.durationMinutes} мин · '
          '${procedure.price.toStringAsFixed(0)} ₽',
      procedureId: procedure.slug ?? procedure.id.toString(),
      spaProcedureId: procedure.id,
    );
  }

  List<SpaChatMessage> _appendMessage(
    List<SpaChatMessage> messages,
    SpaChatMessage message,
  ) {
    return _uniqueMessages([...messages, message]);
  }

  List<SpaChatMessage> _uniqueMessages(List<SpaChatMessage> messages) {
    final byId = <String, SpaChatMessage>{};
    for (final message in messages) {
      byId[message.id] = message;
    }
    final result = byId.values.toList();
    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return result;
  }

  int _latestMessageId(List<SpaChatMessage> messages) {
    return messages
        .map((message) => int.tryParse(message.id))
        .whereType<int>()
        .fold<int>(0, (latest, id) => id > latest ? id : latest);
  }

  String _errorText(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Не удалось выполнить запрос. Проверьте подключение к интернету.';
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _wsService?.disconnect();
    return super.close();
  }
}
