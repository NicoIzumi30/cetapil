import 'dart:io';
import 'dart:ui';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/category_dropdown.dart';
import 'package:cetapil_mobile/widget/cities_dropdown.dart';
import 'package:cetapil_mobile/widget/clipped_maps.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../controller/outlet/outlet_controller.dart';
import '../../widget/dropdown_textfield.dart';

class TambahOutlet extends GetView<OutletController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EnhancedBackButton(
                        onPressed: () => showStyledDialog(context),
                        backgroundColor: Colors.white,
                        iconColor: Colors.blue,
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tambah Outlet", style: AppTextStyle.titlePage),
                                SizedBox(height: 20),
                                // Your existing form fields here
                                ModernTextField(
                                  title: "Nama Sales",
                                  controller: controller.salesName.value,
                                ),
                                ModernTextField(
                                  title: "Nama Outlet",
                                  controller: controller.outletName.value,
                                ),
                                CityDropdown(
                                  title: "Kabupaten/Kota",
                                  controller: controller,
                                ),
                                CategoryDropdown(
                                  title: "Kategori Outlet",
                                  controller: controller,
                                ),
                                ModernTextField(
                                  title: "Alamat Outlet",
                                  controller: controller.outletAddress.value,
                                  maxlines: 4,
                                ),
                                // Location fields
                                Row(
                                  children: [
                                    Expanded(
                                      child: ModernTextField(
                                        enable: false,
                                        title: "Longitude",
                                        controller: controller.gpsController.longController.value,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: ModernTextField(
                                        enable: false,
                                        title: "Latitude",
                                        controller: controller.gpsController.latController.value,
                                      ),
                                    ),
                                  ],
                                ),
                                // Map preview
                                if (controller.gpsController.latController.value.text.isNotEmpty)
                                  MapPreviewWidget(
                                    latitude: double.parse(
                                        controller.gpsController.latController.value.text),
                                    longitude: double.parse(
                                        controller.gpsController.longController.value.text),
                                    zoom: 14.0,
                                    height: 250,
                                    borderRadius: 10,
                                  ),
                                SizedBox(height: 20),
                                // Image upload section
                                Text(
                                  "Foto Outlet",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildImageUploader(
                                      context,
                                      "Foto Tampak Depan Outlet",
                                      0,
                                      controller,
                                    ),
                                    SizedBox(width: 8),
                                    _buildImageUploader(
                                      context,
                                      "Foto Banner/Neon Box Outlet",
                                      1,
                                      controller,
                                    ),
                                    SizedBox(width: 8),
                                    _buildImageUploader(
                                      context,
                                      "Foto Patokan Jalan Outlet",
                                      2,
                                      controller,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                // Survey form section
                                Text("Formulir Survey Outlet", style: AppTextStyle.titlePage),
                                SizedBox(height: 20),
                                _buildSurveyForm(),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              // Bottom buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: Row(
                      children: [
                        _buildButton(
                          false,
                          "Simpan Draft",
                          () => controller.saveDraftOutlet(),
                        ),
                        SizedBox(width: 10),
                        _buildButton(
                          true,
                          "Kirim",
                          () => controller.submitApiOutlet(),
                          // controller.submitOutlet(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future showStyledDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah anda yakin ?'),
                SizedBox(height: 10),
                Text('Progress anda akan hilang ketika keluar'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: Text('Yes'),
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    String title,
    int index,
    OutletController controller,
  ) {
    return Expanded(
      child: Column(
        children: [
          Obx(() {
            final image = controller.outletImages[index];
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
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEDF8FF),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
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
                                Icon(Icons.file_upload_outlined, color: Colors.blue),
                                Text(
                                  "Klik disini untuk unggah",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  "Ukuran maksimal foto 200KB",
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
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            );
          }),
          Text(
            title,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyForm() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.questions.isEmpty) {
        return Center(child: Text("No Form"));
      }

      return Column(
        children: List.generate(
          controller.questions.length,
          (index) => controller.questions[index].type == "bool"
              ? CustomDropdown(
                  title: controller.questions[index].question ?? "",
                  items: ["Sudah", "Belum"],
                  value: controller.controllers[index].text.isNotEmpty
                      ? controller.controllers[index].text
                      : null,
                  hint: "-- Pilih salah satu pilihan dibawah ini --",
                  onChanged: (value) {
                    controller.controllers[index].text = value!;
                  },
                )
              : ModernTextField(
                  keyboardType: TextInputType.number,
                  title: controller.questions[index].question ?? "",
                  controller: controller.controllers[index],
                ),
        ),
      );
    });
  }

  Expanded _buildButton(bool isSubmit, String title, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSubmit ? AppColors.primary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSubmit ? BorderSide.none : BorderSide(color: AppColors.primary),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isSubmit ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Custom dialog to show image preview
class ImagePreviewDialog extends StatelessWidget {
  final File image;
  final VoidCallback onDelete;

  const ImagePreviewDialog({
    Key? key,
    required this.image,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                image,
                fit: BoxFit.cover,
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton.icon(
                  icon: Icon(Icons.check, color: Colors.green),
                  label: Text('OK', style: TextStyle(color: Colors.green)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to show image preview
extension ImagePreviewExtension on BuildContext {
  Future<void> showImagePreview(File image, VoidCallback onDelete) {
    return showDialog(
      context: this,
      builder: (context) => ImagePreviewDialog(
        image: image,
        onDelete: onDelete,
      ),
    );
  }
}
