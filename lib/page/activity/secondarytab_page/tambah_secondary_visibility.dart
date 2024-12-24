import 'dart:io';

import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controller/activity/tambah_visibility_controller.dart';
import '../../../controller/support_data_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_upload.dart';
import '../../../widget/back_button.dart';
import '../../../widget/custom_switch.dart';
import '../../../widget/text_field.dart';
import '../secondarytab_detail_page/survey.dart';

const String BASE_URL = 'https://dev-cetaphil.i-am.host/storage/';

class TambahSecondaryVisibility extends GetView<TambahVisibilityController> {
  final String id;
  TambahSecondaryVisibility({
    super.key, required this.id,
  });
  final supportController = Get.find<SupportDataController>();

  String? _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    if (imagePath.startsWith('data:image') || imagePath.startsWith('/9j/')) {
      return null;
    }

    String path =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$BASE_URL$path';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                          onPressed: () => Alerts.showConfirmDialog(context,
                              useGetBack: false),
                          backgroundColor: Colors.white,
                          iconColor: Colors.blue,
                          useGetBack: false,
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              buildSecondaryYesNo(),
                              Text(
                                "jika tidak ada isi dengan data palsu *",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 9),
                              ),
                              Divider(
                                color: Colors.black12,
                              ),
                              ModernTextField(
                                title: "Tipe Display *",
                                controller: controller.tipeDisplay.value,
                              ),
                              _buildImageUploader(context, "Foto Display *"),
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
                        onPressed: () => controller.saveSecondaryVisibility(id),
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

  Row buildSecondaryYesNo() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Apakah ada Secondary Display ?",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Obx(() => CustomSegmentedSwitch(
              value: controller.toggleSecondaryYesNo.value,
              onChanged: (value) {
                controller.toggleSecondaryYesNo.toggle();
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.white,
            )),
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
          final image = controller.displayImages.value;
          final isUploading = controller.isdisplayImageUploading.value;

          return GestureDetector(
            onTap: isUploading
                ? null
                : () async {
                    final File? result =
                        await ImageUploadUtils.showImageSourceSelection(context,
                            currentImage: image);
                    if (result != null) {
                      controller.updatedisplayImage(result);
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
                              "Klik disini untuk ambil foto dengan kasssmera",
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
                                onTap: () =>
                                    controller.updatedisplayImage(null),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close,
                                      size: 16, color: Colors.red),
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
