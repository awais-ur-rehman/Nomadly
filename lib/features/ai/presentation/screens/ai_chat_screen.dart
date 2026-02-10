import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/ai_provider.dart';
import '../widgets/ai_builder_card.dart';
import '../widgets/ai_place_card.dart';
import '../../../../core/constants/app_colors.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch real quota from backend on screen load
    Future.microtask(() {
      ref.read(aiProvider.notifier).fetchQuota();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _sendMessage() {
      final text = _controller.text.trim();
      if (text.isEmpty) return;
      ref.read(aiProvider.notifier).sendMessage(text);
      _controller.clear();
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
            );
          }
      });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nomi AI', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          _buildQuotaBadge(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty 
            ? _buildEmptyState()
            : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          if (state.isLoading)
             const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: LinearProgressIndicator(color: AppColors.primary, backgroundColor: AppColors.surface)),
          if (state.error != null && !state.rateLimitHit)
             Padding(padding: const EdgeInsets.all(8.0), child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red))),
          if (state.rateLimitHit)
            _buildUpgradePrompt(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildQuotaBadge() {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(aiProvider);
      
      // Don't show anything until quota is loaded
      if (!state.quotaLoaded) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          ),
        );
      }

      final isLow = state.remainingQuota <= 1 && !state.isPremium;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLow ? Colors.red : AppColors.primary.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              state.isPremium ? Icons.verified : Icons.bolt,
              size: 16,
              color: state.isPremium ? Colors.amber : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              state.isPremium ? "Pro" : "${state.remainingQuota} left",
              style: TextStyle(
                color: isLow ? Colors.red : AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 48, color: AppColors.primary.withOpacity(0.6)),
            const SizedBox(height: 16),
            const Text(
              "Hey! I'm Nomi 👋",
              style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Your Nomadly Co-Pilot. Ask me about campsites, nearby nomads, builders, or anything road-life related!",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Column(
      crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUser ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomRight: message.isUser ? Radius.zero : null,
              bottomLeft: !message.isUser ? Radius.zero : null,
            ),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: AppColors.white, fontSize: 15, height: 1.4),
          ),
        ),
        if (!message.isUser && message.structuredData != null)
           _buildStructuredData(message.structuredData),
           
         const SizedBox(height: 4),
         Text(
             _formatTime(message.timestamp),
             style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
         ),
      ],
    );
  }

  String _formatTime(DateTime time) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildStructuredData(dynamic data) {
    if (data is! List) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 220, // Height for cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          if (item['type'] == 'builder') {
             return AiBuilderCard(
                 id: item['id'] ?? '',
                 name: item['name'] ?? 'Unknown',
                 rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                 specialties: List<String>.from(item['specialty'] ?? item['specialties'] ?? []),
                 imageUrl: item['image'],
                 onTap: () {
                     // Navigate to the marketplace to find this builder
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: const Text('Open the Marketplace to view this builder\'s full profile'),
                         action: SnackBarAction(
                           label: 'Go',
                           onPressed: () => context.push('/marketplace'),
                         ),
                         backgroundColor: AppColors.surface,
                       ),
                     );
                 },
             );
          } else if (item['type'] == 'place') {
              return AiPlaceCard(
                  id: item['id'] ?? '',
                  name: item['name'] ?? 'Unknown Place',
                  rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
                  description: item['description'] ?? '',
                  onTap: () {
                      final id = item['id'];
                      if (id != null && id.toString().isNotEmpty) {
                        context.push('/activity/$id');
                      }
                  },
              );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUpgradePrompt() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.2), Colors.amber.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "You've used all your free queries today!",
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Upgrade to Pro for 100 daily queries.",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/subscription'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Upgrade", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40), // Extra bottom padding for safe area logic usually handled by SafeArea but rigid here
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Ask Nomi...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: AppColors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
