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

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedImages.isEmpty) return;

    if (_isUploading) return;
    setState(() => _isUploading = true);

    try {
      List<String> uploadedUrls = [];
      
      // Upload images if any
      if (_selectedImages.isNotEmpty) {
        final uploadService = ImageUploadService();
        for (final file in _selectedImages) {
          final url = await uploadService.uploadImage(file, type: 'post');
          if (url != null) {
            uploadedUrls.add(url);
          }
        }
      }

      // 3. Create Post
      await ref.read(socialProvider.notifier).createPost(
        content,
        photos: uploadedUrls,
      );

      // 4. Reload feed to show the new post
      await ref.read(socialProvider.notifier).loadFeed(refresh: true);

      if (mounted) {
        ToastService.showSuccess('Post created!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError('Post error: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _pickCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
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
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What's on your mind, nomad?",
                  border: InputBorder.none,
                ),
                autofocus: true,
              ),
            ),
            
            // Image Preview
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImages.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const Divider(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: AppColors.primary),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                  onPressed: _pickCamera,
                ),
                const Spacer(),
                const Text('Public', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
