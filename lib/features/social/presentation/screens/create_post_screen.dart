import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/social_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() && _selectedImages.isEmpty) {
      return;
    }

    final content = _contentController.text.trim();
    if (content.isNotEmpty && content.length < 5) {
      ToastService.showError('Text must be at least 5 characters');
      return;
    }

    if (content.isEmpty && _selectedImages.isEmpty) {
      ToastService.showError('Please add text or an image');
      return;
    }

    if (_isUploading) return;
    setState(() => _isUploading = true);

    try {
      List<String> uploadedUrls = [];
      if (_selectedImages.isNotEmpty) {
        final uploadService = ImageUploadService();
        for (final file in _selectedImages) {
          final url = await uploadService.uploadImage(file, type: 'post');
          if (url != null) uploadedUrls.add(url);
        }
      }

      await ref.read(socialProvider.notifier).createPost(content, photos: uploadedUrls);
      await ref.read(socialProvider.notifier).loadFeed(refresh: true);

      if (mounted) {
        ToastService.showSuccess('Post created!');
        context.pop();
      }
    } catch (e) {
      if (mounted) ToastService.showError('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _submit,
              child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind, nomad?",
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.trim().length < 5) {
                      return 'Post must be at least 5 characters';
                    }
                    return null;
                  },
                ),
              ),
              
              const Divider(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined, color: AppColors.primary),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  const Spacer(),
                  const Text('Public', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
