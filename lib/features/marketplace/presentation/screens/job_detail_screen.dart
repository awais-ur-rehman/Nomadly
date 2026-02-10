import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/shared/models/job.dart';
import 'package:nomadly/shared/services/toast_service.dart';
import 'package:nomadly/features/auth/providers/auth_provider.dart';
import 'package:nomadly/features/chat/providers/chat_provider.dart';
import 'package:nomadly/features/marketplace/providers/marketplace_provider.dart';
import 'package:nomadly/features/marketplace/presentation/widgets/job_application_bottom_sheet.dart';
import 'package:nomadly/shared/services/revenue_cat_service.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  final Job? preloadedJob;

  const JobDetailScreen({super.key, required this.jobId, this.preloadedJob});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  Job? _job;
  bool _isLoading = false;
  bool _hasApplied = false;
  String? _applicationStatus; // pending, interview, hired, rejected

  @override
  void initState() {
    super.initState();
    _job = widget.preloadedJob;
    if (_job == null) {
      _loadJob();
    } else {
      _checkApplicationStatus();
    }
  }

  Future<void> _checkApplicationStatus() async {
    if (_isOwnJob()) return;
    try {
      final applications = await ref.read(marketplaceRepositoryProvider).getMyApplications();
      final match = applications.where((a) => a.job?.id == widget.jobId).toList();
      if (match.isNotEmpty && mounted) {
        setState(() {
          _hasApplied = true;
          _applicationStatus = match.first.status;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadJob() async {
    setState(() => _isLoading = true);
    try {
      final job = await ref.read(marketplaceRepositoryProvider).getJob(widget.jobId);
      if (mounted) {
        setState(() => _job = job);
        _checkApplicationStatus();
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError('Failed to load job: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electrical':
      case 'solar':
        return '⚡';
      case 'mechanical':
      case 'diesel':
        return '🔧';
      case 'tech':
      case 'coding':
        return '💻';
      case 'writing':
        return '✍️';
      case 'education':
        return '📚';
      case 'photography':
        return '📸';
      case 'design':
        return '🎨';
      default:
        return '💼';
    }
  }

  Future<void> _contactAuthor() async {
    setState(() => _isLoading = true);
    
    try {
      final authorId = _job?.author.id;
      if (authorId == null) {
        ToastService.showError('Cannot contact: Author ID missing');
        return;
      }
      final conversation = await ref.read(chatListProvider.notifier).createConversation(authorId);
      
      if (conversation != null && mounted) {
        context.push('/chat/${conversation.id}', extra: conversation);
      } else if (mounted) {
        ToastService.showError('Could not start conversation');
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError('Failed to contact: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _applyForJob() async {
    final job = _job;
    if (job == null) return;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobApplicationBottomSheet(job: job),
    );

    if (result == true && mounted) {
      setState(() => _hasApplied = true);
    }
  }

  Future<void> _handleCompleteJob(Job job) async {
    // 1. Confirm with user
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slate,
        title: Text(job.status == 'completed' ? 'Finalize Payment?' : 'Complete Job & Pay Fee?', 
            style: const TextStyle(color: AppColors.white)),
        content: const Text(
          'Marking this job as completed requires a service fee of \$4.99 via Google Play. Proceed?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pay & Complete', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      // 2. Initiate Backend Completion (only if not already completed)
      if (job.status != 'completed') {
        final paymentData = await ref.read(marketplaceRepositoryProvider).completeJob(job.id);
        if (paymentData == null) {
          throw Exception('Failed to initiate job completion');
        }
      }

      // 3. Initiate RevenueCat Purchase
      final package = await RevenueCatService().getJobPaymentPackage();
      if (package != null) {
        final transactionId = await RevenueCatService().purchaseJobPayment(package);

        if (transactionId != null) {
          // 4. Record Payment on Backend
          await ref.read(marketplaceRepositoryProvider).recordJobPayment(
            jobId: job.id,
            transactionId: transactionId,
            amount: 4.99,
          );
          
          if (mounted) {
            ToastService.showSuccess('Payment successful! Job completed.');
            _loadJob(); // Refresh UI
          }
        } else {
             ToastService.showError('Purchase cancelled or failed');
             _loadJob(); // Refresh to show "Finalize Payment" button if status changed
        }
      } else {
        ToastService.showError('Payment configuration error. Please contact support.');
      }

    } catch (e) {
      if (mounted) ToastService.showError('Error completing job: $e');
      _loadJob();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isOwnJob() {
    final currentUser = ref.read(authProvider).user;
    if (currentUser == null || _job == null) return false;
    final currentUserId = currentUser.id ?? currentUser.idSecondary;
    final authorId = _job!.author.id ?? _job!.author.idSecondary;
    return currentUserId != null && currentUserId == authorId;
  }

  Widget _buildActionButton(Job job) {
    // If this is the user's own job, show "View Applications"
    if (_isOwnJob()) {
      if (job.status == 'closed') {
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.slate,
            disabledBackgroundColor: AppColors.slate,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Job Completed', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
        );
      }

      if (job.status == 'completed') {
         // Retry Payment State
         return ElevatedButton(
          onPressed: _isLoading ? null : () => _handleCompleteJob(job),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: AppColors.obsidian,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.obsidian)))
              : const Text('Finalize Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        );
      }

      if (job.status == 'in_progress') {
        return ElevatedButton(
          onPressed: _isLoading ? null : () => _handleCompleteJob(job),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.obsidian,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.obsidian)))
              : const Text('Complete Job', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        );
      }
      return ElevatedButton(
        onPressed: () => context.push('/my-jobs'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 20),
            SizedBox(width: 8),
            Text(
              'View Applications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // For other users: Apply / Already Applied / Job Closed
    return ElevatedButton(
      onPressed: _isLoading || _hasApplied || job.status != 'open'
          ? null
          : _applyForJob,
      style: ElevatedButton.styleFrom(
        backgroundColor: _hasApplied ? AppColors.textSecondary : AppColors.primary,
        foregroundColor: _hasApplied ? AppColors.white : AppColors.obsidian,
        disabledBackgroundColor: AppColors.obsidian,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _hasApplied ? Icons.check_circle : Icons.send,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _hasApplied
                      ? 'Already Applied'
                      : job.status == 'open'
                          ? 'Apply Now'
                          : 'Job Closed',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _job == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final job = _job;
    if (job == null) {
      return Scaffold(
        backgroundColor: AppColors.obsidian,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_off, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              const Text(
                'Job not found',
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image/Gradient
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Pattern overlay
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(
                          painter: _DotPatternPainter(),
                        ),
                      ),
                    ),
                    // Category icon
                    Positioned(
                      right: 30,
                      bottom: 40,
                      child: Text(
                        _getCategoryIcon(job.category),
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: AppColors.white, size: 20),
                ),
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text: 'Check out this job: ${job.title} on Nomadly!\nBudget: \$${job.budget.toStringAsFixed(0)}\nCategory: ${job.category}',
                      subject: 'Job Opportunity: ${job.title}',
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.obsidian,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      
                      // Title & Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              job.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _StatusBadge(status: job.status),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Posted date
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Posted ${_formatDate(job.createdAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Budget & Type Cards
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.attach_money,
                              iconColor: Colors.green,
                              title: 'Budget',
                              value: '\$${job.budget.toStringAsFixed(0)}',
                              subtitle: job.budgetType == 'fixed' ? 'Fixed Price' : 'Per Hour',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              icon: job.isRemote ? Icons.public : Icons.location_on,
                              iconColor: AppColors.primary,
                              title: 'Location',
                              value: job.isRemote ? 'Remote' : 'On-site',
                              subtitle: job.isRemote ? 'Work from anywhere' : 'Local only',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Category
                      _SectionTitle(title: 'Category'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_getCategoryIcon(job.category), style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              job.category.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const _SectionTitle(title: 'Description'),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.slate,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          job.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Posted By Section
                      const _SectionTitle(title: 'Posted By'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.slate,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: job.author.profile?.photoUrl != null
                                  ? NetworkImage(job.author.profile!.photoUrl!)
                                  : null,
                              backgroundColor: AppColors.primaryLight,
                              child: job.author.profile?.photoUrl == null
                                  ? Text(
                                      (job.author.profile?.name ?? job.author.username ?? 'U').substring(0, 1).toUpperCase(),
                                      style: const TextStyle(color: Colors.white, fontSize: 24),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          job.author.profile?.name ?? job.author.username ?? 'Unknown',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      if (job.author.nomadId?.verified == true) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified, size: 18, color: AppColors.primary),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '@${job.author.username ?? 'unknown'}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final authorId = job.author.uid;
                                if (authorId.isNotEmpty) {
                                  context.push('/user/$authorId');
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              child: const Text(
                                'View Profile',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Bottom spacing for button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Action Button
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Application status banner
          if (_applicationStatus != null && !_isOwnJob())
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _getStatusColor(_applicationStatus!).withValues(alpha: 0.15),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(_applicationStatus!),
                    color: _getStatusColor(_applicationStatus!),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(_applicationStatus!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getStatusColor(_applicationStatus!),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.slate,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Budget display
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.budgetType == 'fixed' ? 'Fixed Price' : 'Hourly Rate',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${job.budget.toStringAsFixed(0)}${job.budgetType == 'hourly' ? '/hr' : ''}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Action button — context-aware
              Expanded(
                flex: 2,
                child: _buildActionButton(job),
              ),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'hired': return Colors.green;
      case 'interview': return Colors.blue;
      case 'pending': return Colors.amber;
      case 'rejected': return Colors.red;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'hired': return Icons.check_circle;
      case 'interview': return Icons.event;
      case 'pending': return Icons.hourglass_empty;
      case 'rejected': return Icons.cancel;
      default: return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'hired': return 'You have been hired for this job!';
      case 'interview': return 'You have been selected for an interview';
      case 'pending': return 'Your application is under review';
      case 'rejected': return 'Your application was not selected';
      default: return 'Application status: $status';
    }
  }
}

// --- Helper Widgets ---

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'open':
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        color = AppColors.warning;
        icon = Icons.pending;
        break;
      case 'closed':
        color = AppColors.error;
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase().replaceAll('_', ' '),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Dot pattern painter for the header
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const radius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
