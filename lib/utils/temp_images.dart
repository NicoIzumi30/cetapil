import 'dart:io';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class TempImageStorage {
  static final TempImageStorage _instance = TempImageStorage._internal();
  final _uuid = Uuid();

  factory TempImageStorage() {
    return _instance;
  }

  TempImageStorage._internal();

  /// Save image with distinction between draft and temporary
  Future<String> saveImage(
    File imageFile, {
    String category = 'default',
    bool isDraft = false, // New parameter to indicate if it's a draft
  }) async {
    try {
      final directory =
          await (isDraft ? _getDraftDirectory(category) : _getTempDirectory(category));

      final String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      final String filePath = path.join(directory.path, fileName);

      // Copy the image to appropriate storage
      await imageFile.copy(filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Get file from storage path
  Future<File?> getFile(String? filePath) async {
    if (filePath == null) return null;

    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Error getting file: $e');
      return null;
    }
  }

  /// Delete a specific image
  Future<void> deleteImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Get file path for API upload
  Future<String?> getImagePathForUpload(String? filePath) async {
    if (filePath == null) return null;

    try {
      final file = await getFile(filePath);
      if (file != null && await file.exists()) {
        return file.path;
      }
      return null;
    } catch (e) {
      print('Error getting image for upload: $e');
      return null;
    }
  }

  void viewImage(BuildContext context, String? imagePath) {
    if (imagePath == null) return;

    final file = File(imagePath);
    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image not found')));
      return;
    }

    ImageUploadUtils.showImageViewer(context, file);
  }

  /// View image with preview widget
  Widget buildImagePreview(
    String? imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    VoidCallback? onTap,
    Widget Function()? placeholderBuilder,
  }) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return placeholderBuilder?.call() ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
          );
    }

    return GestureDetector(
      onTap: onTap,
      child: Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholderBuilder?.call() ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: Icon(Icons.error_outline, color: Colors.grey[400]),
              );
        },
      ),
    );
  }

  /// Gets the base temporary directory
  Future<Directory> _getBaseTempDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory tempDir = Directory(path.join(appDir.path, 'temp_images'));

    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
    }

    return tempDir;
  }

  /// Gets the base drafts directory
  Future<Directory> _getBaseDraftDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory draftDir = Directory(path.join(appDir.path, 'draft_images'));

    if (!await draftDir.exists()) {
      await draftDir.create(recursive: true);
    }

    return draftDir;
  }

  /// Gets or creates the temporary directory for a specific category
  Future<Directory> _getTempDirectory(String category) async {
    final baseDir = await _getBaseTempDirectory();
    final Directory categoryDir = Directory(path.join(baseDir.path, category));

    if (!await categoryDir.exists()) {
      await categoryDir.create(recursive: true);
    }

    return categoryDir;
  }

  /// Gets or creates the draft directory for a specific category
  Future<Directory> _getDraftDirectory(String category) async {
    final baseDir = await _getBaseDraftDirectory();
    final Directory categoryDir = Directory(path.join(baseDir.path, category));

    if (!await categoryDir.exists()) {
      await categoryDir.create(recursive: true);
    }

    return categoryDir;
  }


  /// Clean up only temporary images in a category (not drafts)
  Future<void> cleanupTempCategory(String category) async {
    try {
      final directory = await _getTempDirectory(category);
      if (await directory.exists()) {
        await for (var entity in directory.list()) {
          if (entity is File) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error cleaning up temporary category: $e');
    }
  }

  /// Clean up all temporary images (not drafts)
  Future<void> cleanupAllTemp() async {
    try {
      final baseDir = await _getBaseTempDirectory();
      if (await baseDir.exists()) {
        await for (var entity in baseDir.list()) {
          if (entity is Directory) {
            await for (var file in entity.list()) {
              if (file is File) {
                await file.delete();
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error cleaning up all temporary images: $e');
    }
  }

  /// Move image from temp to draft storage
  Future<String> moveToTempDraft(String tempPath, String category) async {
    try {
      final draftDir = await _getDraftDirectory(category);
      final String fileName = path.basename(tempPath);
      final String draftPath = path.join(draftDir.path, fileName);

      final file = File(tempPath);
      if (await file.exists()) {
        await file.copy(draftPath);
        await file.delete(); // Delete the temp file
      }

      return draftPath;
    } catch (e) {
      throw Exception('Failed to move image to draft storage: $e');
    }
  }

  /// Check if path is in draft storage
  bool isDraftPath(String filePath) {
    return filePath.contains('draft_images');
  }

  /// Check if path is in temporary storage
  bool isTempPath(String filePath) {
    return filePath.contains('temp_images');
  }

  /// Checks if a file exists
  Future<bool> exists(String filePath) async {
    return await File(filePath).exists();
  }
}
