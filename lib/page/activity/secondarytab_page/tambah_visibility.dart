import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_upload.dart';
import '../../../widget/back_button.dart';
import '../../../widget/dialog.dart';
import '../../../widget/dropdown_textfield.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage/';

class TambahVisibility extends GetView<TambahVisibilityController> {
  String? _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    if (imagePath.startsWith('data:image') || imagePath.startsWith('/9j/')) {
      return null;
    }

    String path = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$BASE_URL$path';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        final shouldPop = await Alerts.showConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EnhancedBackButton(
                          onPressed: () => Alerts.showConfirmDialog(context, useGetBack: false),
                          backgroundColor: Colors.white,
                          iconColor: Colors.blue,
                          useGetBack: false,
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildReadOnlyField(
                                label: "Jenis Visibility",
                                value: controller.posmType.value,
                              ),
                              _buildReadOnlyField(
                                label: "Jenis Visual",
                                value: controller.visualType.value,
                              ),
                              Text(
                                "Planogram",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: controller.visibility?.image != null
                                      ? _buildPlanogramImage(controller.visibility?.image)
                                      : Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child:
                                                Icon(Icons.image_not_supported, color: Colors.grey),
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 15),
                              CustomDropdown(
                                  hint: "-- Pilih condition --",
                                  value: controller.selectedCondition.value.isEmpty
                                      ? null
                                      : controller.selectedCondition.value,
                                  items: ["Good", "Bad"].map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedCondition.value = value!;
                                  },
                                  title: "Condition"),
                              _buildImageUploader(context, "Foto Visibility 1", 0),
                              _buildImageUploader(context, "Foto Visibility 2", 1),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        onPressed: () => controller.saveVisibility(),
                        child: Text(
                          "Simpan Visibility",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanogramImage(String? image) {
    final imageUrl = _getImageUrl(image);

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: Icon(Icons.error),
        ),
      );
    } else if (image!.startsWith('data:image') || image.startsWith('/9j/')) {
      try {
        return Image.memory(
          base64Decode(image.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.error),
          ),
        );
      } catch (e) {
        print('Error loading base64 image: $e');
        return Container(
          color: Colors.grey[200],
          child: Icon(Icons.error),
        );
      }
    }

    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3FF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploader(BuildContext context, String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Obx(() {
          final image = controller.visibilityImages[index];
          final isUploading = controller.isImageUploading[index];

          return GestureDetector(
            onTap: isUploading
                ? null
                : () async {
                    final File? result = await ImageUploadUtils.showImageSourceSelection(context);
                    if (result != null) {
                      controller.updateImage(index, result);
                    }
                  },
            child: Container(
              width: double.infinity,
              height: 150,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFFEDF8FF),
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(8),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isUploading
                  ? Center(child: CircularProgressIndicator())
                  : image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.black),
                            Text(
                              "Klik disini untuk ambil foto dengan kamera",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "Kualitas foto harus jelas dan tidak blur",
                              style: TextStyle(fontSize: 7, color: Colors.blue),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => controller.updateImage(index, null),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, size: 16, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
        }),
      ],
    );
  }
}
