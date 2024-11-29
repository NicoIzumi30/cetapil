import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_activity_controller.dart';
import '../../../controller/outlet/outlet_controller.dart';
import '../../../model/dropdown_model.dart' as Model;
import '../../../model/list_posm_response.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_upload.dart';
import '../../../widget/back_button.dart';
import '../../../widget/dialog.dart';
import '../../../widget/dropdown_textfield.dart';

class TambahVisibility extends GetView<TambahActivityController> {
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
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EnhancedBackButton(
                        onPressed: () => Alerts.showConfirmDialog(context),
                        backgroundColor: Colors.white,
                        iconColor: Colors.blue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Obx(() {
                              if (controller.isLoadingAvailability.value) {
                                return CircularProgressIndicator();
                              } else {
                                return DropdownApi(
                                  label: "Jenis Visibility",
                                  items: controller.itemsPOSM.map((item) {
                                    return DropdownMenuItem<Model.Data>(
                                      value: item, // Use the ID as the value
                                      child: Text(item.name ?? ''), // Display the name
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedPOSM.value = value!.name!;
                                    controller.selectedIdPOSM.value = value.id!;
                                    // if (!controller.selectedItems.contains(value)) {
                                    //   controller.selectedItems.add(value!);
                                    // }
                                  },
                                );
                              }
                            }),
                            Obx(() {
                              if (controller.isLoadingAvailability.value) {
                                return CircularProgressIndicator();
                              } else {
                                return DropdownApi(
                                  label: "Jenis Visual",
                                  items: controller.itemsVisual.map((item) {
                                    return DropdownMenuItem<Model.Data>(
                                      value: item, // Use the ID as the value
                                      child: Text(item.name ?? ''), // Display the name
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedVisual.value = value!.name!;
                                    controller.selectedIdVisual.value = value.id!;
                                    // if (!controller.selectedItems.contains(value)) {
                                    //   controller.selectedItems.add(value!);
                                    // }
                                  },
                                );
                              }
                            }),
                            Text(
                              "Planogram",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/carousel1.png"),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomDropdown(
                                hint: "-- Pilih condition --",
                                items: ["Good", "Bad"].map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item ?? ''), // Display the name
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedCondition.value = value!;
                                },
                                title: "Condition"),
                            _buildImageUploader(
                              context,
                              "Foto Visibility 1",
                              0,
                              controller,
                            ),
                            _buildImageUploader(
                              context,
                              "Foto Visibility 2",
                              1,
                              controller,
                            )
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
                      onPressed: () => controller.insertVisibility(),
                      child: Text(
                        " Tambah Visibility",
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
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    String title,
    int index,
      TambahActivityController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10,),
        Obx(() {
          final image = controller.visibilityImages[index];
          final isUploading = controller.isImageUploading[index];

          return GestureDetector(
            onTap: isUploading
                ? null
                : () async {
                    final File? result =
                        await ImageUploadUtils.showImageSourceSelection(
                            context);
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
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
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
                            Icon(Icons.camera_alt,
                                color: Colors.black),
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
                              style: TextStyle(
                                  fontSize: 7, color: Colors.blue),
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
                                    controller.updateImage(index, null),
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
          );
        }),

      ],
    );
  }
}

class DropdownApi extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<Model.Data>> items;
  final Function(Model.Data?) onChanged;

  const DropdownApi({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
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
          child: DropdownButtonFormField<Model.Data>(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFE8F3FF),
            ),
            hint: Text(
              "-- Pilih $label --",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.blue, // Match your theme color
            ),
            items: items,
            // controller.itemsPOSM.map((item) {
            //   return DropdownMenuItem<Data>(
            //     value: item, // Use the ID as the value
            //     child: Text(item.name ?? ''), // Display the name
            //   );
            // }).toList(),
            onChanged: onChanged,
            //     (value) {
            //   if (!controller.selectedItems.contains(value)) {
            //     controller.selectedItems.add(value!);
            //   }
            // },
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
