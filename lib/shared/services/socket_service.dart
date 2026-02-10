import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';
import '../../core/config/app_config.dart';
import 'secure_storage_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final _logger = Logger();
  final _storage = SecureStorageService();

  bool get isConnected => _socket?.connected ?? false;

  // Initialize and connect to Socket.IO server
  Future<void> connect() async {
    if (_socket?.connected == true) {
      // _logger.d('Socket already connected');
      return;
    }

    try {
      final token = await _storage.getAccessToken();
      if (token == null) {
        _logger.w('No access token found - cannot connect to socket');
        return;
      }

      _socket = IO.io(
        AppConfig.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setAuth({'token': token})
            .build(),
      );

      _setupListeners();
      _socket!.connect();

      // _logger.d('Socket connection initiated');
    } catch (e) {
      _logger.e('Error connecting to socket: $e');
    }
  }

  // Setup default event listeners
  void _setupListeners() {
    _socket?.on('connect', (_) {
      // _logger.d('Socket connected');
    });

    _socket?.on('disconnect', (_) {
      _logger.w('Socket disconnected');
    });

    _socket?.on('connect_error', (error) {
      _logger.e('Socket connection error: $error');
    });

    _socket?.on('error', (error) {
      _logger.e('Socket error: $error');
    });
  }

  // Disconnect from socket
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    // _logger.d('Socket disconnected and disposed');
  }

  // Join a chat conversation
  void joinChat(String conversationId) {
    if (!isConnected) {
      _logger.w('Socket not connected - cannot join chat');
      return;
    }

    _socket!.emit('join_chat', conversationId);
    // _logger.d('Joined chat: $conversationId');
  }

  // Leave a chat conversation
  void leaveChat(String conversationId) {
    if (!isConnected) return;

    _socket!.emit('leave_chat', conversationId);
    // _logger.d('Left chat: $conversationId');
  }

  // Send a message
  void sendMessage({
    required String conversationId,
    required String message,
    String messageType = 'text',
  }) {
    if (!isConnected) {
      _logger.w('Socket not connected - cannot send message');
      return;
    }

    _socket!.emit('send_message', {
      'conversationId': conversationId,
      'message': message,
      'messageType': messageType,
    });

    // _logger.d('Message sent to conversation: $conversationId');
  }

  // Send typing indicator
  void sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) {
    if (!isConnected) return;

    _socket!.emit('typing', {
      'conversationId': conversationId,
      'isTyping': isTyping,
    });
  }

  // Mark messages as read
  void markAsRead(String conversationId) {
    if (!isConnected) return;

    _socket!.emit('mark_read', conversationId);
    // _logger.d('Marked messages as read: $conversationId');
  }

  // Listen for incoming messages
  void onReceiveMessage(Function(dynamic) callback) {
    _socket?.on('receive_message', callback);
  }

  // Listen for typing indicators
  void onTyping(Function(dynamic) callback) {
    _socket?.on('typing', callback);
  }

  // Listen for read receipts
  void onReadReceipt(Function(dynamic) callback) {
    _socket?.on('read_receipt', callback);
  }

  // Listen for custom events
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  // Remove event listener
  void off(String event) {
    _socket?.off(event);
  }

  // Emit custom event
  void emit(String event, [dynamic data]) {
    if (!isConnected) {
      _logger.w('Socket not connected - cannot emit event: $event');
      return;
    }

    _socket!.emit(event, data);
  }
}
