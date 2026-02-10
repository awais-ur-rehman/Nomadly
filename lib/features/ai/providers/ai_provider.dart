import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/ai_repository.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final dynamic structuredData;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.structuredData,
  });
}

class AiState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final int remainingQuota; // -1 = not loaded yet
  final int limit;
  final bool isPremium;
  final bool quotaLoaded;
  final bool rateLimitHit;

  AiState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.remainingQuota = -1,
    this.limit = 5,
    this.isPremium = false,
    this.quotaLoaded = false,
    this.rateLimitHit = false,
  });

  AiState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    int? remainingQuota,
    int? limit,
    bool? isPremium,
    bool? quotaLoaded,
    bool? rateLimitHit,
  }) {
    return AiState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remainingQuota: remainingQuota ?? this.remainingQuota,
      limit: limit ?? this.limit,
      isPremium: isPremium ?? this.isPremium,
      quotaLoaded: quotaLoaded ?? this.quotaLoaded,
      rateLimitHit: rateLimitHit ?? this.rateLimitHit,
    );
  }
}

final aiRepositoryProvider = Provider((ref) => AiRepository());

final aiProvider = StateNotifierProvider<AiNotifier, AiState>((ref) {
  return AiNotifier(ref.watch(aiRepositoryProvider));
});

class AiNotifier extends StateNotifier<AiState> {
  final AiRepository _repository;

  AiNotifier(this._repository) : super(AiState(messages: []));

  /// Fetch quota from backend on screen init (does NOT consume a credit)
  Future<void> fetchQuota() async {
    try {
      final data = await _repository.fetchQuota();
      state = state.copyWith(
        remainingQuota: data['remaining'] ?? 5,
        limit: data['limit'] ?? 5,
        isPremium: data['isPremium'] ?? false,
        quotaLoaded: true,
      );
    } catch (e) {
      // Fallback to free defaults
      state = state.copyWith(
        remainingQuota: 5,
        limit: 5,
        isPremium: false,
        quotaLoaded: true,
      );
    }
  }

  /// Build conversation history for multi-turn context
  List<Map<String, String>> _buildHistory() {
    return state.messages.map((m) => {
      'role': m.isUser ? 'user' : 'model',
      'text': m.text,
    }).toList();
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
      rateLimitHit: false,
    );

    try {
      final history = _buildHistory();
      // Don't include the current message in history since the backend receives it separately
      final historyWithoutCurrent = history.sublist(0, history.length - 1);

      final data = await _repository.sendMessage(
        text,
        history: historyWithoutCurrent.isNotEmpty ? historyWithoutCurrent : null,
      );
      final responseText = data['response'] as String;
      final usage = data['usage'];

      String cleanText = responseText;
      dynamic structuredData;

      // Extract JSON block if present: ```json ... ```
      final jsonBlockRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
      final match = jsonBlockRegex.firstMatch(responseText);

      if (match != null) {
        try {
          final jsonString = match.group(1);
          if (jsonString != null) {
            structuredData = jsonDecode(jsonString);
            cleanText = responseText.replaceAll(match.group(0)!, '').trim();
          }
        } catch (e) {
          print('JSON Parse Error: $e');
        }
      }

      final aiMessage = ChatMessage(
        text: cleanText,
        isUser: false,
        timestamp: DateTime.now(),
        structuredData: structuredData,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        remainingQuota: usage?['remaining'],
        limit: usage?['limit'],
        isPremium: usage?['isPremium'],
      );
    } catch (e) {
      final errorMsg = e.toString();
      final isRateLimit = errorMsg.contains("daily Nomi limit") ||
          errorMsg.contains("RATE_LIMIT");

      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
        rateLimitHit: isRateLimit,
      );
    }
  }
  
  void reset() {
      state = AiState(messages: []);
  }
}
