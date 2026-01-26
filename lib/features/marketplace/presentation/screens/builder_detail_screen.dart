import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/models/builder.dart';
import '../../providers/marketplace_provider.dart';

class BuilderDetailScreen extends ConsumerStatefulWidget {
  final BuilderProfile builder;

  const BuilderDetailScreen({
    super.key,
    required this.builder,
  });

  @override
  ConsumerState<BuilderDetailScreen> createState() => _BuilderDetailScreenState();
}

class _BuilderDetailScreenState extends ConsumerState<BuilderDetailScreen> {
  final _messageController = TextEditingController();
  List<BuilderReview> _reviews = [];
  bool _isLoadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoadingReviews = true);
    try {
      final reviews = await ref.read(marketplaceRepositoryProvider).getBuilderReviews(widget.builder.id);
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() => _isLoadingReviews = false);
    }
  }

  Future<void> _requestConsultation() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    try {
      await ref.read(marketplaceRepositoryProvider).requestConsultation(widget.builder.id, msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Consultation request sent!')));
        Navigator.pop(context);
      }
    } catch (e) {
      // Handled by repo/provider
    }
  }

  void _showConsultModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Request Consultation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell the builder about your project...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestConsultation,
              child: const Text('Send Request'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.builder.businessName),
              background: widget.builder.portfolioImageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.builder.portfolioImageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Container(color: AppColors.primary),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStat('Rating', '${widget.builder.rating} ⭐'),
                      const SizedBox(width: 24),
                      _buildStat('Projects', '${widget.builder.portfolioImageUrls.length}'),
                      const SizedBox(width: 24),
                      _buildStat('Verified', widget.builder.isVerified ? 'Yes' : 'No'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    widget.builder.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  const Text('Specialties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: widget.builder.specialty.map((s) => Chip(label: Text(s.toUpperCase()))).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Portfolio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.builder.portfolioImageUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.builder.portfolioImageUrls[index],
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (_isLoadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No reviews yet.'),
                    )
                  else
                    ..._reviews.map((r) => ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(r.authorPhotoUrl)),
                          title: Text(r.authorName),
                          subtitle: Text(r.comment),
                          trailing: Text('${r.rating} ⭐'),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _showConsultModal,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Book Consultation'),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
