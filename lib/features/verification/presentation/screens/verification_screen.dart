import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/verification.dart';
import '../../../../shared/services/toast_service.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../providers/verification_provider.dart';
import '../../../profile/presentation/widgets/verification_badge.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(verificationProvider.notifier).loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationProvider);
    final v = state.verification;

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
          'Verification',
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
          : v == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Unable to load verification status',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(verificationProvider.notifier).loadStatus(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Retry', style: TextStyle(fontFamily: 'Outfit')),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(verificationProvider.notifier).loadStatus(),
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildHeader(v),
                      const SizedBox(height: 24),
                      _buildProgressBar(v.level),
                      const SizedBox(height: 24),
                      _buildEmailCard(v.email),
                      _buildPhoneCard(v.phone),
                      _buildPhotoCard(v.photo),
                      _buildCommunityCard(v.community),
                      _buildIdCard(v.idDocument),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(Verification v) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          VerificationBadge(level: v.level, size: 48, showLabel: true),
          const SizedBox(height: 12),
          Text(
            'Level ${v.level} / 5',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _levelDescription(v.level),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _levelDescription(int level) {
    return switch (level) {
      0 => 'Complete steps below to increase your trust level.',
      1 => 'Basic verification. Verify your phone to level up.',
      2 => 'Trusted member. Submit a selfie to level up.',
      3 => 'Verified! Get community vouches to level up.',
      4 => 'Super Verified! Submit ID for the highest level.',
      _ => 'Nomad Elite — maximum trust level achieved!',
    };
  }

  Widget _buildProgressBar(int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VERIFICATION PROGRESS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.4),
            fontFamily: 'Outfit',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: level / 5,
            minHeight: 12,
            backgroundColor: AppColors.slate,
            valueColor: AlwaysStoppedAnimation<Color>(
              level >= 4 ? Colors.amber.shade700 : level >= 2 ? AppColors.primary : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailCard(VerificationItem? email) {
    final verified = email?.status == 'verified';
    return _StepCard(
      icon: Icons.email_outlined,
      title: 'Email',
      status: verified ? 'Verified' : 'Pending',
      statusColor: verified ? Colors.green : Colors.orange,
      subtitle: 'Verified during registration',
      trailing: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
    );
  }

  Widget _buildPhoneCard(PhoneVerification? phone) {
    final status = phone?.status ?? 'none';
    final verified = status == 'verified';
    final pending = status == 'pending' || status == 'submitted';

    return _StepCard(
      icon: Icons.phone_outlined,
      title: 'Phone Number',
      status: verified ? 'Verified' : pending ? 'Under Review' : 'Not Submitted',
      statusColor: verified ? Colors.green : pending ? Colors.orange : Colors.grey,
      subtitle: verified
          ? 'Phone verified'
          : pending
              ? 'Your phone number is being reviewed'
              : 'Add your phone number for verification',
      trailing: verified
          ? const Icon(Icons.check_circle, color: Colors.green)
          : pending
              ? const Icon(Icons.hourglass_top, color: Colors.orange)
              : null,
      action: (!verified && !pending) ? () => _showPhoneDialog() : null,
      actionLabel: 'Submit',
    );
  }

  Widget _buildPhotoCard(PhotoVerification? photo) {
    final status = photo?.status ?? 'none';
    final verified = status == 'verified';
    final pending = status == 'pending' || status == 'submitted';
    final rejected = status == 'rejected';

    return _StepCard(
      icon: Icons.camera_alt_outlined,
      title: 'Photo Verification',
      status: verified ? 'Verified' : pending ? 'Under Review' : rejected ? 'Rejected' : 'Not Submitted',
      statusColor: verified ? Colors.green : pending ? Colors.orange : rejected ? Colors.red : Colors.grey,
      subtitle: verified
          ? 'Selfie verified'
          : rejected
              ? 'Reason: ${photo?.rejectionReason ?? "Unknown"}. Please resubmit.'
              : pending
                  ? 'Your selfie is being reviewed'
                  : 'Take a selfie to verify your identity',
      trailing: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
      action: (!verified && !pending) ? () => _submitSelfie() : null,
      actionLabel: rejected ? 'Resubmit' : 'Submit',
    );
  }

  Widget _buildCommunityCard(CommunityVerification? community) {
    final status = community?.status ?? 'none';
    final verified = status == 'verified';
    final vouchCount = community?.vouchCount ?? 0;

    return _StepCard(
      icon: Icons.people_outline,
      title: 'Community Vouches',
      status: verified ? 'Verified' : '$vouchCount / 3 vouches',
      statusColor: verified ? Colors.green : Colors.orange,
      subtitle: verified
          ? 'Community verification complete'
          : 'Ask other verified nomads to vouch for you',
      trailing: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
      action: !verified
          ? () async {
              final ok = await ref.read(verificationProvider.notifier).refreshCommunity();
              if (mounted) {
                ok ? ToastService.showSuccess('Community status refreshed') : ToastService.showError('Failed to refresh');
              }
            }
          : null,
      actionLabel: 'Refresh',
    );
  }

  Widget _buildIdCard(IdDocVerification? idDoc) {
    final status = idDoc?.status ?? 'none';
    final verified = status == 'verified';
    final pending = status == 'pending' || status == 'submitted';
    final rejected = status == 'rejected';

    return _StepCard(
      icon: Icons.badge_outlined,
      title: 'ID Document',
      status: verified ? 'Verified' : pending ? 'Under Review' : rejected ? 'Rejected' : 'Not Submitted',
      statusColor: verified ? Colors.green : pending ? Colors.orange : rejected ? Colors.red : Colors.grey,
      subtitle: verified
          ? 'ID document verified'
          : rejected
              ? 'Reason: ${idDoc?.rejectionReason ?? "Unknown"}. Please resubmit.'
              : pending
                  ? 'Your document is being reviewed'
                  : 'Upload a government-issued ID',
      trailing: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
      action: (!verified && !pending) ? () => _showIdDocDialog() : null,
      actionLabel: rejected ? 'Resubmit' : 'Submit',
    );
  }

  void _showPhoneDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Submit Phone Number',
          style: TextStyle(color: AppColors.white, fontFamily: 'Outfit'),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: AppColors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: '+1 234 567 8900',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            filled: true,
            fillColor: AppColors.obsidian,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.phone, color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ),
          TextButton(
            onPressed: () async {
              final phone = controller.text.trim();
              if (phone.isEmpty) { ToastService.showError('Enter a phone number'); return; }
              Navigator.pop(ctx);
              final ok = await ref.read(verificationProvider.notifier).submitPhone(phone);
              if (mounted) ok ? ToastService.showSuccess('Phone submitted for review') : ToastService.showError('Failed to submit');
            },
            child: const Text('Submit', style: TextStyle(color: AppColors.primary, fontFamily: 'Outfit')),
          ),
        ],
      ),
    );
  }

  Future<void> _submitSelfie() async {
    try {
      final file = await ImageUploadService().pickFromCamera(crop: false);
      if (file == null) return;
      final url = await ImageUploadService().uploadImage(file, type: 'verification');
      if (url == null) return;
      final ok = await ref.read(verificationProvider.notifier).submitPhoto(url);
      if (mounted) ok ? ToastService.showSuccess('Selfie submitted for review') : ToastService.showError('Failed to submit');
    } catch (e) {
      ToastService.showError('Failed to upload selfie');
    }
  }

  void _showIdDocDialog() {
    String? selectedType;
    const docTypes = [
      ('drivers_license', "Driver's License"),
      ('passport', 'Passport'),
      ('national_id', 'National ID'),
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.slate,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Submit ID Document',
            style: TextStyle(color: AppColors.white, fontFamily: 'Outfit'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Document type:',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              ...docTypes.map((t) => RadioListTile<String>(
                value: t.$1,
                groupValue: selectedType,
                title: Text(t.$2, style: const TextStyle(fontSize: 14, color: AppColors.white, fontFamily: 'Inter')),
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                onChanged: (v) => setDialogState(() => selectedType = v),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
            ),
            TextButton(
              onPressed: () async {
                if (selectedType == null) { ToastService.showError('Select a document type'); return; }
                Navigator.pop(ctx);
                try {
                  final file = await ImageUploadService().pickFromGallery();
                  if (file == null) return;
                  final url = await ImageUploadService().uploadImage(file, type: 'verification');
                  if (url == null) return;
                  final ok = await ref.read(verificationProvider.notifier).submitIdDocument(url, selectedType!);
                  if (mounted) ok ? ToastService.showSuccess('Document submitted for review') : ToastService.showError('Failed to submit');
                } catch (_) {
                  ToastService.showError('Failed to upload document');
                }
              },
              child: const Text('Upload & Submit', style: TextStyle(color: AppColors.primary, fontFamily: 'Outfit')),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final Color statusColor;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? action;
  final String? actionLabel;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.subtitle,
    this.trailing,
    this.action,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Outfit',
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
              fontFamily: 'Inter',
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: action,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  actionLabel ?? 'Submit',
                  style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
