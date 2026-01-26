import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/conversation.dart';
import '../../../../shared/models/message.dart';
import '../../../../shared/services/socket_service.dart';
import '../data/repositories/chat_repository.dart';

// Providers
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

// State for Conversation List
class ChatListState {
  final List<Conversation> conversations;
  final bool isLoading;
  final String? error;

  ChatListState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Conversation List Notifier
class ChatListNotifier extends StateNotifier<ChatListState> {
  final ChatRepository _repository;
  final SocketService _socketService;

  ChatListNotifier(this._repository)
      : _socketService = SocketService(),
        super(ChatListState()) {
    loadConversations();
    _initSocket();
  }

  void _initSocket() {
    _socketService.connect();
    // Listen for updates that affect conversation list (e.g. new message in any chat causes resort)
    // For simplicity in Phase 1, we might just reload or listen to specific events
    // Ideally, update the specific conversation in the list via socket event
  }

  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true);
    try {
      final conversations = await _repository.getConversations();
      state = state.copyWith(isLoading: false, conversations: conversations);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Conversation?> createConversation(String targetUserId) async {
    try {
      final conversation = await _repository.createConversation(targetUserId);
      // Add to list if not exists or update
      // For now reload list to be safe
      await loadConversations();
      return conversation;
    } catch (e) {
      return null;
    }
  }
}

final chatListProvider = StateNotifierProvider<ChatListNotifier, ChatListState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatListNotifier(repository);
});


// State for Active Chat (Message List)
class ActiveChatState {
  final String? conversationId;
  final List<Message> messages;
  final bool isLoading;
  final String? error;
  final bool isTyping; // Generic for "someone is typing"

  ActiveChatState({
    this.conversationId,
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.isTyping = false,
  });

  ActiveChatState copyWith({
    String? conversationId,
    List<Message>? messages,
    bool? isLoading,
    String? error,
    bool? isTyping,
  }) {
    return ActiveChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

// Active Chat Notifier
class ActiveChatNotifier extends StateNotifier<ActiveChatState> {
  final ChatRepository _repository;
  final SocketService _socketService;

  ActiveChatNotifier(this._repository)
      : _socketService = SocketService(),
        super(ActiveChatState());

  void setActiveConversation(String conversationId) {
    if (state.conversationId == conversationId) return;
    
    // Leave previous room if any
    if (state.conversationId != null) {
      _socketService.leaveChat(state.conversationId!);
      _socketService.off('receive_message');
      _socketService.off('typing');
    }

    state = ActiveChatState(conversationId: conversationId, isLoading: true);
    _loadMessages(conversationId);
    
    // Join new room
    _socketService.joinChat(conversationId);
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketService.onReceiveMessage((data) {
       // Allow dynamic data handling, assume it matches Message structure or is JSON
       try {
         final message = Message.fromJson(data);
         // Append to list
         state = state.copyWith(messages: [message, ...state.messages]);
       } catch (e) {/* log error */}
    });

    _socketService.onTyping((data) {
      final isTyping = data['isTyping'] as bool? ?? false;
      state = state.copyWith(isTyping: isTyping);
    });
  }

  Future<void> _loadMessages(String conversationId) async {
    try {
      final messages = await _repository.getMessages(conversationId);
      state = state.copyWith(isLoading: false, messages: messages);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String messageContent) async {
    if (state.conversationId == null) return;
    
    // Optimistic update skipped due to missing AuthProvider reference for 'me' user.
    // Relying on API response and Socket updates.
    
    try {
      // 1. Send via API
      final sentMessage = await _repository.sendMessage(
        conversationId: state.conversationId!,
        message: messageContent,
      );
      
      // 2. Add to list (if socket hasn't already)
      // Check if message with this ID exists (socket might have delivered it)
      if (!state.messages.any((m) => m.id == sentMessage.id)) {
        state = state.copyWith(
           messages: [sentMessage, ...state.messages]
        );
      }
      
      // 3. Socket emission is likely handled by backend upon POST
    } catch (e) {
      // Show error
      state = state.copyWith(error: 'Failed to send: ${e.toString()}');
    }
  }
  
  void sendTyping(bool isTyping) {
    if (state.conversationId == null) return;
    _socketService.sendTypingIndicator(
      conversationId: state.conversationId!,
      isTyping: isTyping,
    );
  }
  
  @override
  void dispose() {
    if (state.conversationId != null) {
       _socketService.leaveChat(state.conversationId!);
    }
    super.dispose();
  }
}

final activeChatProvider = StateNotifierProvider<ActiveChatNotifier, ActiveChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ActiveChatNotifier(repository);
});
