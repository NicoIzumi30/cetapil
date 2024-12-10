import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/activity/tambah_activity_controller.dart';
import '../../controller/support_data_controller.dart';

class TambahVisibilityController extends GetxController {
  late TambahActivityController activityController = Get.find<TambahActivityController>();
  // final supportDataController = Get.find<SupportDataController>();

  final posmType = ''.obs;
  final posmTypeId = ''.obs;
  final visualType = ''.obs;
  final visualTypeId = ''.obs;
  final selectedCondition = ''.obs;
  final RxList<File?> visibilityImages = RxList([null, null]);
  final RxList<bool> isImageUploading = RxList([false, false]);
  dynamic visibility;

  void editItem(Map<String, dynamic> item) {
    clearForm();

    final visibilityId = item['visibility']?.id;
    final existingDraft = activityController.visibilityDraftItems
        .firstWhereOrNull((draft) => draft['id'] == visibilityId);

    if (existingDraft != null) {
      posmType.value = existingDraft['posm_type_name'];
      posmTypeId.value = existingDraft['posm_type_id'];
      visualType.value = existingDraft['visual_type_name'];
      visualTypeId.value = existingDraft['visual_type_id'];
      selectedCondition.value = existingDraft['condition'] ?? 'Good';

      if (existingDraft['image1'] != null) {
        visibilityImages[0] = existingDraft['image1'];
      }
      if (existingDraft['image2'] != null) {
        visibilityImages[1] = existingDraft['image2'];
      }
    } else {
      if (item['posmType'] != null) {
        posmType.value = item['posmType']['name'] ?? '';
        posmTypeId.value = item['posmType']['id'] ?? '';
      }
      if (item['visualType'] != null) {
        visualType.value = item['visualType']['name'] ?? '';
        visualTypeId.value = item['visualType']['id'] ?? '';
      }
      selectedCondition.value = 'Good';
    }

    visibility = item['visibility'];
    update();
  }

  void updateImage(int index, File? file) {
    visibilityImages[index] = file;
    activityController.updateVisibilityImage(index, file);
    update();
  }

  bool validateForm() {
    List<String> missingFields = [];

    if (posmTypeId.value.isEmpty) {
      missingFields.add('Jenis Visibility');
    }
    if (visualTypeId.value.isEmpty) {
      missingFields.add('Jenis Visual');
    }
    if (selectedCondition.value.isEmpty) {
      missingFields.add('Condition');
    }
    if (visibilityImages[0] == null) {
      missingFields.add('Foto Visibility 1');
    }
    if (visibilityImages[1] == null) {
      missingFields.add('Foto Visibility 2');
    }

    if (missingFields.isNotEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text('Required Fields'),
          content: Text('Please fill in the following fields:\n\n${missingFields.join('\n')}'),
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

  void saveVisibility() {
    if (!validateForm()) return;

    final data = {
      'id': visibility?.id ?? DateTime.now().toString(),
      'posm_type_id': posmTypeId.value,
      'posm_type_name': posmType.value,
      'visual_type_id': visualTypeId.value,
      'visual_type_name': visualType.value,
      'condition': selectedCondition.value,
      'image1': visibilityImages[0],
      'image2': visibilityImages[1],
    };

    activityController.addVisibilityItem(data);
    clearForm();
    Get.back();
  }

  void clearForm() {
    posmType.value = '';
    posmTypeId.value = '';
    visualType.value = '';
    visualTypeId.value = '';
    selectedCondition.value = '';
    visibilityImages.value = [null, null];
    isImageUploading.value = [false, false];
    visibility = null;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
