import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/invite_provider.dart';

class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inviteProvider.notifier).loadCodes();
      ref.read(inviteProvider.notifier).loadTree();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inviteProvider);
    final user = ref.watch(authProvider).user;
    final inviteCount = user?.inviteCount ?? 0;

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Invite Codes',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(inviteProvider.notifier).loadCodes();
                await ref.read(inviteProvider.notifier).loadTree();
              },
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Header card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.slate,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Invite Friends to Nomadly',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nomadly is invite-only. Share your codes with fellow nomads.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$inviteCount invites remaining',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: inviteCount <= 0
                          ? null
                          : () async {
                              final ok = await ref.read(inviteProvider.notifier).generateCode();
                              if (mounted) {
                                ok
                                    ? ToastService.showSuccess('Invite code generated!')
                                    : ToastService.showError('Failed to generate code');
                              }
                            },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Generate New Code',
                        style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.slate,
                        disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // My Codes
                  Text(
                    'MY CODES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.4),
                      fontFamily: 'Outfit',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (state.codes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No invite codes yet',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    )
                  else
                    ...state.codes.map((code) => _buildCodeTile(code)),

                  // Invite Tree
                  if (state.tree != null && state.tree!.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(
                      'INVITE TREE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontFamily: 'Outfit',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTreeSection(state.tree!),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCodeTile(Map<String, dynamic> code) {
    final codeStr = code['code'] as String? ?? '';
    final isActive = code['is_active'] as bool? ?? false;
    final useCount = code['use_count'] as int? ?? 0;
    final maxUses = code['max_uses'] as int? ?? 1;
    final codeId = code['_id'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.confirmation_number : Icons.block,
            color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  codeStr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    fontSize: 16,
                    color: isActive ? AppColors.white : Colors.white.withValues(alpha: 0.3),
                    decoration: isActive ? null : TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Used $useCount / $maxUses',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          if (isActive) ...[
            IconButton(
              icon: Icon(Icons.copy, size: 20, color: Colors.white.withValues(alpha: 0.7)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: codeStr));
                ToastService.showSuccess('Code copied!');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: () async {
                final ok = await ref.read(inviteProvider.notifier).revokeCode(codeId);
                if (mounted) {
                  ok
                      ? ToastService.showSuccess('Code revoked')
                      : ToastService.showError('Failed to revoke');
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTreeSection(Map<String, dynamic> tree) {
    final invitees = tree['invitees'] as List? ?? [];
    if (invitees.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No one invited yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontFamily: 'Inter',
            ),
          ),
        ),
      );
    }

    return Column(
      children: invitees.map<Widget>((invitee) {
        final name = invitee['profile']?['name'] ?? invitee['username'] ?? 'Nomad';
        final date = invitee['created_at'] != null
            ? DateTime.tryParse(invitee['created_at'].toString())
            : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.slate,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (date != null)
                      Text(
                        'Joined ${date.month}/${date.day}/${date.year}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
