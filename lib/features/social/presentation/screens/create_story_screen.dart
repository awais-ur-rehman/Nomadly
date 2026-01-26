import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/services/image_upload_service.dart';
import '../../../../shared/services/toast_service.dart';
import '../../providers/social_provider.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final image = await ImageUploadService().pickFromGallery(crop: false);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickCamera() async {
    final image = await ImageUploadService().pickFromCamera(crop: false);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _uploadStory() async {
    if (_selectedImage == null) return;
    
    setState(() => _isUploading = true);
    
    try {
      // 1. Upload Image
      final url = await ImageUploadService().uploadImage(
        _selectedImage!, 
        type: 'story',
      );
      
      if (url == null) {
        throw Exception('Failed to upload image');
      }

      // 2. Create Story
      await ref.read(socialProvider.notifier).createStory(url, type: 'image');
      
      // 3. Reload feed to show the new story
      await ref.read(socialProvider.notifier).loadFeed(refresh: true);
      
      if (mounted) {
        ToastService.showSuccess('Story posted!');
        context.pop(); // Close screen
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError('Story error: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_selectedImage != null)
            TextButton(
              onPressed: _isUploading ? null : _uploadStory,
              child: _isUploading 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Post', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
      ),
      body: Center(
        child: _selectedImage != null
            ? Image.file(_selectedImage!)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 64,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickCamera,
                  ),
                  const SizedBox(height: 16),
                  const Text('Take Photo', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 32),
                  IconButton(
                    iconSize: 64,
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                  const SizedBox(height: 16),
                  const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                ],
              ),
      ),
    );
  }
}
