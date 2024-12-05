// image_upload_utils.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImageUploadUtils {
  static final ImagePicker _picker = ImagePicker();
  static const int maxFileSize = 200 * 1024;

  static void showImageViewer(BuildContext context, dynamic image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(image: image),
      ),
    );
  }

  static Future<File?> showImageSourceSelection(BuildContext context,
      {dynamic currentImage}) async {
    final result = await showModalBottomSheet<dynamic>(
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
              if (currentImage != null)
                ListTile(
                  leading: Icon(Icons.image, color: Colors.blue),
                  title: Text('View Image'),
                  onTap: () {
                    Navigator.pop(context, 'view');
                  },
                ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (result == null) return null;
    if (result == 'view') {
      showImageViewer(context, currentImage!);
      return currentImage;
    }

    try {
      return await pickAndCompressImage(source: result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  static Future<File?> pickAndCompressImage({
    required ImageSource source,
    int quality = 85,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: quality,
      );

      if (pickedFile == null) return null;

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

      if (compressedFile != null) {
        int fileSize = await compressedFile.length();
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

  static Future<String?> convertImageToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Error converting image to base64: $e');
      return null;
    }
  }

  static Future<double> getFileSizeInKB(File file) async {
    final int bytes = await file.length();
    return bytes / 1024;
  }
}

class ImageViewerScreen extends StatelessWidget {
  final dynamic image;

  const ImageViewerScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: PhotoView(
        imageProvider: image is File ? FileImage(image) : NetworkImage(image) as ImageProvider,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}

// Example usage in a widget
class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  Future<void> _handleImageSelection() async {
    final File? result = await ImageUploadUtils.showImageSourceSelection(
      context,
      currentImage: _imageFile,
    );

    if (result != null) {
      setState(() => _imageFile = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imageFile != null)
          Container(
            height: 200,
            width: 200,
            child: Image.file(_imageFile!, fit: BoxFit.cover),
          ),
        ElevatedButton(
          onPressed: _handleImageSelection,
          child: Text(_imageFile == null ? 'Select Image' : 'Change Image'),
        ),
      ],
    );
  }
}
