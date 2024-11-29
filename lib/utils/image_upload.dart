import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';

class ImageUploadUtils {
  static final ImagePicker _picker = ImagePicker();
  
  // Maximum file size in bytes (200KB)
  static const int maxFileSize = 200 * 1024;

  /// Shows bottom sheet for picking image source and handles the upload process
  static Future<File?> showImageSourceSelection(BuildContext context) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.photo_library, color: Colors.blue),
              //   title: Text('Choose from Gallery'),
              //   onTap: () {
              //     Navigator.pop(context, ImageSource.gallery);
              //   },
              // ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (source == null) return null;

    try {
      return await pickAndCompressImage(source: source);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Picks image from camera or gallery and compresses it
  static Future<File?> pickAndCompressImage({
    required ImageSource source,
    int quality = 85,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      // Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: quality,
      );

      if (pickedFile == null) return null;

      // Get temp directory for storing compressed image
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      File? compressedFile = await compressImage(
        File(pickedFile.path),
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      // Check if file size is within limits
      if (compressedFile != null) {
        int fileSize = await compressedFile.length();
        
        // If file is still too large, compress again with lower quality
        while (fileSize > maxFileSize && quality > 5) {
          quality -= 10;
          compressedFile = await compressImage(
            File(pickedFile.path),
            targetPath,
            quality: quality,
            minWidth: minWidth,
            minHeight: minHeight,
          );
          fileSize = await compressedFile!.length();
        }

        if (fileSize > maxFileSize) {
          throw Exception('Could not compress image to under 200KB');
        }
      }

      return compressedFile;
    } catch (e) {
      print('Error picking/compressing image: $e');
      rethrow;
    }
  }

  /// Compresses an image file
  static Future<File?> compressImage(
    File file,
    String targetPath, {
    int quality = 85,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Error compressing image: $e');
      rethrow;
    }
  }

  /// Converts image file to base64 string
  static Future<String?> convertImageToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Error converting image to base64: $e');
      return null;
    }
  }

  /// Gets file size in KB
  static Future<double> getFileSizeInKB(File file) async {
    final int bytes = await file.length();
    return bytes / 1024;
  }
}