import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nomadly/core/constants/app_colors.dart';
import 'package:nomadly/core/constants/app_dimensions.dart';
import 'package:nomadly/shared/models/job.dart';
import 'package:nomadly/shared/services/toast_service.dart';
import 'package:nomadly/features/chat/providers/chat_provider.dart';
import 'package:nomadly/features/marketplace/providers/marketplace_provider.dart';
import 'package:nomadly/features/marketplace/presentation/widgets/job_application_bottom_sheet.dart';

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

  @override
  void initState() {
    super.initState();
    _job = widget.preloadedJob;
    if (_job == null) {
      _loadJob();
    }
  }

  Future<void> _loadJob() async {
    setState(() => _isLoading = true);
    try {
      final job = await ref.read(marketplaceRepositoryProvider).getJob(widget.jobId);
      if (mounted) {
        setState(() => _job = job);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _job == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final job = _job;
    if (job == null) {
      return const Scaffold(body: Center(child: Text('Job not found')));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : AppColors.background,
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
                      AppColors.primary.withOpacity(0.8),
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
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  Share.share(
                    'Check out this job: ${job.title} on Nomadly!\nBudget: \$${job.budget.toStringAsFixed(0)}\nCategory: ${job.category}',
                    subject: 'Job Opportunity: ${job.title}',
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
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : AppColors.background,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Posted ${_formatDate(job.createdAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
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
                      _SectionTitle(title: 'Description'),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          job.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Posted By Section
                      _SectionTitle(title: 'Posted By'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                      Text(
                                        job.author.profile?.name ?? job.author.username ?? 'Unknown',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
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
                                    '@${job.author.username}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => context.push('/user/${job.author.id}', extra: job.author),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('View Profile'),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
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
              // Action button (Apply or Contact)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _hasApplied || job.status != 'open' 
                    ? null 
                    : _applyForJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasApplied ? Colors.grey : AppColors.primary,
                    foregroundColor: Colors.white,
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _hasApplied ? Icons.check_circle : Icons.send, 
                              size: 20
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _hasApplied 
                                ? 'Already Applied' 
                                : job.status == 'open' ? 'Apply Now' : 'Job Closed',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'closed':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
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
