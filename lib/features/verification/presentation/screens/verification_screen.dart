import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
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
      appBar: AppBar(title: const Text('Verification')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : v == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Unable to load verification status'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(verificationProvider.notifier).loadStatus(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(verificationProvider.notifier).loadStatus(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            VerificationBadge(level: v.level, size: 48, showLabel: true),
            const SizedBox(height: 12),
            Text(
              'Level ${v.level} / 5',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _levelDescription(v.level),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
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
        const Text('VERIFICATION PROGRESS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: level / 5,
            minHeight: 12,
            backgroundColor: AppColors.greyExtraLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              level >= 4 ? Colors.amber.shade700 : level >= 2 ? Colors.blue : Colors.grey,
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
      action: (!verified && !pending)
          ? () => _showPhoneDialog()
          : null,
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
      action: (!verified && !pending)
          ? () => _submitSelfie()
          : null,
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
      action: (!verified && !pending)
          ? () => _showIdDocDialog()
          : null,
      actionLabel: rejected ? 'Resubmit' : 'Submit',
    );
  }

  void _showPhoneDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Phone Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+1 234 567 8900',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final phone = controller.text.trim();
              if (phone.isEmpty) { ToastService.showError('Enter a phone number'); return; }
              Navigator.pop(ctx);
              final ok = await ref.read(verificationProvider.notifier).submitPhone(phone);
              if (mounted) ok ? ToastService.showSuccess('Phone submitted for review') : ToastService.showError('Failed to submit');
            },
            child: const Text('Submit'),
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
          title: const Text('Submit ID Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Document type:'),
              const SizedBox(height: 8),
              ...docTypes.map((t) => RadioListTile<String>(
                value: t.$1,
                groupValue: selectedType,
                title: Text(t.$2, style: const TextStyle(fontSize: 14)),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setDialogState(() => selectedType = v),
              )),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
              child: const Text('Upload & Submit'),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(status, style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            if (action != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: action,
                  child: Text(actionLabel ?? 'Submit'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
