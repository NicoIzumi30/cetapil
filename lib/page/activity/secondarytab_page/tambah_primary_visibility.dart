import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_upload.dart';
import '../../../widget/back_button.dart';
import '../../../widget/dialog.dart';
import '../../../widget/dropdown_textfield.dart';

const String BASE_URL = 'https://dev.cetaphil.id/storage/';

class TambahPrimaryVisibility extends GetView<TambahVisibilityController> {
  final String id;

  TambahPrimaryVisibility({
    super.key,
    required this.id,
  });

  final supportController = Get.find<SupportDataController>();

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
      onWillPop: () async {
        final shouldPop = await Alerts.showConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand, // Added to ensure Stack fills available space
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
                            onPressed: () => Alerts.showConfirmDialog(
                                context, useGetBack: false),
                            backgroundColor: Colors.white,
                            iconColor: Colors.blue,
                            useGetBack: false,
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              children: [
                                Obx(() {
                                  return CustomDropdown(
                                    hint: "-- Pilih Jenis Display --",
                                    value: controller.posmTypeId.value.isEmpty
                                        ? null
                                        : controller.posmTypeId.value,
                                    items: supportController.getPosmTypes()
                                        .map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['id'],
                                        child: Text(item['name']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.posmTypeId.value = value!;
                                      controller.posmType.value =
                                      supportController
                                          .getPosmTypes()
                                          .firstWhere((element) =>
                                      element['id'] == value)['name'];

                                      print(" id : ${controller.posmTypeId
                                          .value}");
                                    },
                                    title: "Jenis Display",
                                  );
                                }),
                                Obx(() {
                                  return CustomDropdown(
                                    hint: "-- Pilih Jenis Visual --",
                                    value: controller.visualTypeId.value.isEmpty
                                        ? null
                                        : controller.visualTypeId.value,
                                    items: supportController.getVisualTypes()
                                        .map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['id'],
                                        child: Text(item['name']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.visualTypeId.value = value!;
                                      controller.visualType.value =
                                      supportController
                                          .getVisualTypes()
                                          .firstWhere((element) =>
                                      element['id'] == value)['name'];
                                      print(controller.visualType.value);
                                      if (controller.visualType.value ==
                                          "Others") {
                                        controller.isOtherVisual.value = true;
                                      } else {
                                        controller.isOtherVisual.value = false;
                                      }
                                    },
                                    title: "Jenis Visual",
                                  );
                                }),
                                Obx(() {
                                  return Visibility(
                                    visible: controller.isOtherVisual.value,
                                    child: ModernTextField(
                                      title: "Others Visual",
                                      controller: controller
                                          .otherVisualController.value,
                                    ),
                                  );
                                }),
                                Text(
                                  "Planogram",
                                  style: TextStyle(fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FutureBuilder<
                                        List<Map<String, dynamic>>>(
                                      future: supportController
                                          .getPlanogramsByChannel(controller
                                          .activityController.detailOutlet
                                          .value!.channel!.id ??
                                          ''),
                                      builder: (context, snapshot) {
                                        print(controller
                                            .activityController.detailOutlet
                                            .value!.channel!.id);
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                                child: CircularProgressIndicator()),
                                          );
                                        }

                                        if (snapshot.hasError ||
                                            !snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Text(
                                                "No planogram available for this channel",
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                          );
                                        }

                                        final planogram = snapshot.data!.first;
                                        final planogramPath = planogram['path'];

                                        if (planogramPath != null &&
                                            planogramPath.isNotEmpty) {
                                          final imageUrl = '$BASE_URL$planogramPath';
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      FullScreenImageViewer(
                                                          imageUrl: imageUrl),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: 'planogram_image',
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                          child: CircularProgressIndicator()),
                                                    ),
                                                errorWidget: (context, url,
                                                    error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: Icon(Icons.error),
                                                    ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Text(
                                                "Invalid planogram image",
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                CustomDropdown(
                                    hint: "-- Pilih Condition --",
                                    value: controller.selectedCondition.value
                                        .isEmpty
                                        ? null
                                        : controller.selectedCondition.value,
                                    items: ["Good", "Bad"].map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.selectedCondition.value =
                                      value!;
                                    },
                                    title: "Condition"),
                                ModernTextField(
                                  title: "Lebar Rak (cm)",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: controller.lebarRak.value,
                                ),
                                ModernTextField(
                                  title: "Shelving",
                                  controller: controller.shelving.value,
                                  keyboardType: TextInputType.number,
                                ),
                                _buildImageUploader(context, "Foto Visibility"),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          onPressed: () => controller.savePrimaryVisibility(id),
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
      ),
    );
  }

  Widget _buildPlanogramImage(String? image) {
    final imageUrl = _getImageUrl(image);

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Container(
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (context, url, error) =>
            Container(
              color: Colors.grey[200],
              child: Icon(Icons.error),
            ),
      );
    } else if (image!.startsWith('data:image') || image.startsWith('/9j/')) {
      try {
        return Image.memory(
          base64Decode(image
              .split(',')
              .last),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(
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

  Widget _buildImageUploader(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Obx(() {
          final image = controller.visibilityImages.value;
          final isUploading = controller.isVisibilityImageUploading;

          return GestureDetector(
            onTap: isUploading.value
                ? null
                : () async {
              final File? result = await ImageUploadUtils
                  .showImageSourceSelection(context,
                  currentImage: image);
              if (result != null) {
                controller.updateImage(result);
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
              child: isUploading.value
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
                      onTap: () => controller.updateImage(null),
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

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Image with zoom
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: 'planogram_image',
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                    errorWidget: (context, url, error) =>
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
