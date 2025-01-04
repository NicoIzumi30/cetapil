import 'dart:io';
import 'dart:ui';
import 'package:cetapil_mobile/page/outlet/detail_outlet.dart';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:cetapil_mobile/widget/FormActionButton.dart';
import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/category_dropdown.dart';
import 'package:cetapil_mobile/widget/channel_dropdown.dart';
import 'package:cetapil_mobile/widget/cities_dropdown.dart';
import 'package:cetapil_mobile/widget/clipped_maps.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controller/support_data_controller.dart';
import '../../model/form_outlet_response.dart';
import '../../utils/colors.dart';
import '../../controller/outlet/outlet_controller.dart';
import '../../widget/dialog.dart';
import '../../widget/dropdown_textfield.dart';

class TambahOutlet extends GetView<OutletController> {
  final SupportDataController supportController = Get.find<SupportDataController>();
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    final username = storage.read('username') ?? '-';
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
              // Main content wrapped in a single ScrollView
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EnhancedBackButton(
                            onPressed: () => Alerts.showConfirmDialog(context),
                            backgroundColor: Colors.white,
                            iconColor: Colors.blue,
                          ),
                          SizedBox(height: 20),
                          Text("Tambah Outlet", style: AppTextStyle.titlePage),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  // Form content in SliverPadding
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    sliver: SliverToBoxAdapter(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UnderlineTextField.readOnly(
                                title: "Nama Sales",
                                value: username,
                              ),
                              ModernTextField(
                                title: "Nama Outlet",
                                controller: controller.outletName.value,
                              ),
                              CityDropdown(
                                title: "Kabupaten/Kota",
                                controller: controller,
                              ),
                              ChannelDropdown(
                                title: "Channel Outlet",
                                controller: controller,
                              ),
                              CategoryDropdown<OutletController>(
                                title: "Kategori Outlet",
                                controller: controller,
                                selectedCategoryGetter: (controller) => controller.selectedCategory,
                                categoriesGetter: (controller) => controller.categories,
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
                              // Add bottom padding to ensure content isn't covered by the bottom buttons
                              SizedBox(height: 80),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              // Bottom buttons positioned at the bottom
              FormActionButtons(
                onSaveDraft: controller.saveDraftOutlet,
                onSubmit: controller.submitApiOutlet,
              ),
            ],
          ),
        ),
      ),
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
                      final File? result = await ImageUploadUtils.showImageSourceSelection(context,
                          currentImage: image);
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
      final questions = supportController
          .getFormOutlet()
          .map((form) => FormOutletResponse(
                id: form['id'] as String,
                type: form['type'] as String,
                question: form['question'] as String,
              ))
          .toList();

      // Only generate controllers if they haven't been generated yet
      if (controller.controllers.isEmpty) {
        controller.generateControllers();
      }

      return Column(
        children: List.generate(
          questions.length,
          (index) => questions[index].type == "bool"
              ? CustomDropdown(
                  title: questions[index].question ?? "",
                  items: ["Sudah", "Belum"].map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  value: controller.controllers[index].text.isNotEmpty
                      ? controller.controllers[index].text
                      : null,
                  hint: "-- Pilih salah satu pilihan dibawah ini --",
                  onChanged: (value) {
                    if (value != null) {
                      controller.controllers[index].text = value;
                    }
                  },
                )
              : ModernTextField(
                  keyboardType: TextInputType.number,
                  title: questions[index].question ?? "",
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
