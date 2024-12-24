import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/activity/tambah_activity_controller.dart';
import '../../controller/support_data_controller.dart';

class TambahVisibilityController extends GetxController {
  late TambahActivityController activityController =
      Get.find<TambahActivityController>();
  final supportDataController = Get.find<SupportDataController>();

  final posmType = ''.obs;
  final posmTypeId = ''.obs;
  final visualType = ''.obs;
  final visualTypeId = ''.obs;
  final selectedCondition = ''.obs;
  var isOtherVisual = false.obs;
  // final RxList<File?> visibilityImages = RxList([null]);
  // final  File? displayImage = (null);
  final Rx<File?> visibilityImages = Rx<File?>(null);

  final isVisibilityImageUploading = false.obs;

  final Rx<TextEditingController> shelving = TextEditingController().obs;
  final Rx<TextEditingController> lebarRak = TextEditingController().obs;
  final Rx<TextEditingController> otherVisualController = TextEditingController().obs;

  dynamic visibility;

  // void editItem(Map<String, dynamic> item) {
  //   clearPrimaryForm();
  //
  //   final visibilityId = item['visibility']?.id;
  //   final existingDraft = activityController.visibilityDraftItems
  //       .firstWhereOrNull((draft) => draft['id'] == visibilityId);
  //
  //   if (existingDraft != null) {
  //     posmType.value = existingDraft['posm_type_name'];
  //     posmTypeId.value = existingDraft['posm_type_id'];
  //     visualType.value = existingDraft['visual_type_name'];
  //     visualTypeId.value = existingDraft['visual_type_id'];
  //     selectedCondition.value = existingDraft['condition'] ?? 'Good';
  //
  //     if (existingDraft['image1'] != null) {
  //       visibilityImages.value = existingDraft['image1'];
  //     }
  //     // if (existingDraft['image2'] != null) {
  //     //   visibilityImages[1] = existingDraft['image2'];
  //     // }
  //   } else {
  //     if (item['posmType'] != null) {
  //       posmType.value = item['posmType']['name'] ?? '';
  //       posmTypeId.value = item['posmType']['id'] ?? '';
  //     }
  //     if (item['visualType'] != null) {
  //       visualType.value = item['visualType']['name'] ?? '';
  //       visualTypeId.value = item['visualType']['id'] ?? '';
  //     }
  //     selectedCondition.value = 'Good';
  //   }
  //
  //   visibility = item['visibility'];
  //   update();
  // }

  void updateImage(File? file) {
    visibilityImages.value = file;
    // activityController.updateVisibilityImage(file);
    update();
  }

  bool validatePrimaryForm() {
    List<String> missingFields = [];

    if (posmTypeId.value.isEmpty) {
      missingFields.add('Jenis Visibility');
    }
    if (visualTypeId.value.isEmpty) {
      missingFields.add('Jenis Visual');
    }
    if (visualType == "Others") {
      if (otherVisualController.value.text.isEmpty) {
        missingFields.add('Others Visual');
      }
    }
    if (selectedCondition.value.isEmpty) {
      missingFields.add('Condition');
    }
    if (lebarRak.value.text.isEmpty) {
      missingFields.add('Lebar Rak');
    }
    if (shelving.value.text.isEmpty) {
      missingFields.add('Shelving');
    }
    if (visibilityImages.value == null) {
      missingFields.add('Foto Visibility');
    }

    if (missingFields.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text('Required Fields'),
          content: Text(
              'Please fill in the following fields:\n\n${missingFields.join('\n')}'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  void  savePrimaryVisibility(String id) {
    if (!validatePrimaryForm()) return;
    var id_part = id.split('-'); /// (primary, core , 1)
     print(otherVisualController.value.text);
    final data = {
      // 'id': visibility?.id ?? DateTime.now().toString(),
      'id': id,
      'category': id_part[1].toUpperCase(), /// (CORE)
      'position': id_part[2], /// (1)
      'posm_type_id': posmTypeId.value,
      'posm_type_name': posmType.value,
      'visual_type_id': visualTypeId.value,
      'visual_type_name': visualType.value == "Others" ? otherVisualController.value.text : visualType.value,
      'condition': selectedCondition.value,
      'shelf_width': lebarRak.value.text,
      'shelving': shelving.value.text,
      'image_visibility': visibilityImages.value,
    };

    activityController.addPrimaryVisibilityItem(data);
    clearPrimaryForm();
    Get.back();
  }

  void clearPrimaryForm() {
    posmType.value = '';
    posmTypeId.value = '';
    visualType.value = '';
    visualTypeId.value = '';
    selectedCondition.value = '';
    lebarRak.value.clear();
    shelving.value.clear();
    otherVisualController.value.clear();
    isOtherVisual.value = false;
    visibilityImages.value = null;
    isVisibilityImageUploading.value = false;
    visibility = null;
  }



  /// SECONDARY VISIBILITY
  final toggleSecondaryYesNo = false.obs;
  final Rx<TextEditingController> tipeDisplay = TextEditingController().obs;
  final Rx<File?> displayImages = Rx<File?>(null);
  final isdisplayImageUploading = false.obs;

  void updatedisplayImage(File? file) {
    displayImages.value = file;
    // activityController.updateVisibilitySecondaryImage(file);
    update();
  }

  bool validateSecondaryForm() {
    List<String> missingFields = [];

    if (tipeDisplay.value.text.isEmpty) {
      missingFields.add('Tipe Display');
    }
    if (displayImages.value == null) {
      missingFields.add('Foto Display');
    }

    if (missingFields.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text('Required Fields'),
          content: Text(
              'Please fill in the following fields:\n\n${missingFields.join('\n')}'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  void saveSecondaryVisibility(String id) {
    if (!validateSecondaryForm()) return;
    var id_part = id.split('-'); /// (secondaru, core , 1)
    final data = {
      // 'id': visibility?.id ?? DateTime.now().toString(),
      'id': id,
      'category': id_part[1].toUpperCase(), /// (CORE)
      'position': id_part[2], /// (1)
     'secondary_exist': toggleSecondaryYesNo.toString(),
      'display_type': tipeDisplay.value.text,
      'display_image': displayImages.value,
    };

    activityController.addSecondaryVisibilityItem(data);
    clearSecondaryForm();
    Get.back();
  }

  void clearSecondaryForm() {
    toggleSecondaryYesNo.value = false;
    tipeDisplay.value.clear();
    displayImages.value = null;
    isdisplayImageUploading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
