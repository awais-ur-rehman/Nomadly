import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import '../../core/config/app_config.dart';
import '../../core/constants/app_colors.dart';
import 'api_client.dart';
import 'toast_service.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  final _picker = ImagePicker();
  final _logger = Logger();
  final _apiClient = ApiClient();

  // Pick image from gallery
  Future<File?> pickFromGallery({bool crop = true}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 70,
      );

      if (pickedFile == null) return null;

      if (crop) {
        return await _cropImage(File(pickedFile.path));
      }

      return File(pickedFile.path);
    } catch (e) {
      _logger.e('Error picking image from gallery: $e');
      ToastService.showError('Failed to pick image');
      return null;
    }
  }

  // Pick image from camera
  Future<File?> pickFromCamera({bool crop = true}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 70,
      );

      if (pickedFile == null) return null;

      if (crop) {
        return await _cropImage(File(pickedFile.path));
      }

      return File(pickedFile.path);
    } catch (e) {
      _logger.e('Error picking image from camera: $e');
      ToastService.showError('Failed to capture image');
      return null;
    }
  }

  // Crop image
  Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    } catch (e) {
      _logger.e('Error cropping image: $e');
      // Return original image if cropping fails
      return imageFile;
    }
  }

  // Upload image to Cloudinary via backend API
  Future<String?> uploadImage(
    File imageFile, {
    String type = 'default',
    Function(int, int)? onProgress,
  }) async {
    try {
      // Check file size
      final fileSize = await imageFile.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      if (fileSizeMB > AppConfig.maxImageSizeMB) {
        ToastService.showError(
          'Image size must be less than ${AppConfig.maxImageSizeMB}MB',
        );
        return null;
      }

      // Upload to backend
      final response = await _apiClient.uploadFile(
        '${AppConfig.uploadEndpoint}/image?type=$type',
        imageFile.path,
        fileKey: 'image',
        onSendProgress: onProgress,
      );

      if (response.statusCode == 201) {
        final imageUrl = response.data['data']['url'] as String;
        _logger.d('Image uploaded successfully: $imageUrl');
        return imageUrl;
      }

      ToastService.showError('Failed to upload image');
      return null;
    } catch (e) {
      _logger.e('Error uploading image: $e');
      ToastService.showError('Failed to upload image');
      return null;
    }
  }

  // Show image source selection bottom sheet
  Future<File?> showImageSourceSelection({
    required Function() onCameraSelected,
    required Function() onGallerySelected,
  }) async {
    // This will be implemented in the UI layer
    // For now, just pick from gallery
    return await pickFromGallery();
  }

  // Upload profile photo
  Future<String?> uploadProfilePhoto(File imageFile) async {
    return await uploadImage(imageFile, type: 'profile');
  }

  // Upload chat image
  Future<String?> uploadChatImage(File imageFile) async {
    return await uploadImage(imageFile, type: 'chat');
  }

  // Upload activity image
  Future<String?> uploadActivityImage(File imageFile) async {
    return await uploadImage(imageFile, type: 'activity');
  }

  // Upload rig image
  Future<String?> uploadRigImage(File imageFile) async {
    return await uploadImage(imageFile, type: 'rig');
  }
}
