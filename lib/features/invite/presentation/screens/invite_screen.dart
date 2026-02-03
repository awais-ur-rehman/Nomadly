import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
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
      appBar: AppBar(title: const Text('Invite Codes')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(inviteProvider.notifier).loadCodes();
                await ref.read(inviteProvider.notifier).loadTree();
              },
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                children: [
                  // Header card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.card_giftcard, size: 48, color: AppColors.primary),
                          const SizedBox(height: 12),
                          const Text(
                            'Invite Friends to Nomadly',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nomadly is invite-only. Share your codes with fellow nomads.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$inviteCount invites remaining',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

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
                      label: const Text('Generate New Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Codes
                  const Text(
                    'MY CODES',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),

                  if (state.codes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('No invite codes yet', style: TextStyle(color: AppColors.grey))),
                    )
                  else
                    ...state.codes.map((code) => _buildCodeTile(code)),

                  // Invite Tree
                  if (state.tree != null && state.tree!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'INVITE TREE',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isActive ? Icons.confirmation_number : Icons.block,
          color: isActive ? AppColors.primary : AppColors.grey,
        ),
        title: Text(
          codeStr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
            color: isActive ? AppColors.textPrimary : AppColors.grey,
            decoration: isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text('Used $useCount / $maxUses'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive) ...[
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
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
      ),
    );
  }

  Widget _buildTreeSection(Map<String, dynamic> tree) {
    final invitees = tree['invitees'] as List? ?? [];
    if (invitees.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('No one invited yet', style: TextStyle(color: AppColors.grey))),
      );
    }

    return Column(
      children: invitees.map<Widget>((invitee) {
        final name = invitee['profile']?['name'] ?? invitee['username'] ?? 'Nomad';
        final date = invitee['created_at'] != null
            ? DateTime.tryParse(invitee['created_at'].toString())
            : null;

        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(name),
          subtitle: date != null
              ? Text('Joined ${date.month}/${date.day}/${date.year}')
              : null,
          dense: true,
        );
      }).toList(),
    );
  }
}
