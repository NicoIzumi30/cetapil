// tambah_visibility_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/activity/tambah_activity_controller.dart';

class TambahVisibilityController extends GetxController {
  final activityController = Get.find<TambahActivityController>();

  // Form fields
  final posmType = ''.obs;
  final posmTypeId = ''.obs;
  final visualType = ''.obs;
  final visualTypeId = ''.obs;
  final selectedCondition = ''.obs;
  final RxList<File?> visibilityImages = RxList([null, null]);
  final RxList<bool> isImageUploading = RxList([false, false]);
  dynamic visibility; // Make this dynamic

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from previous page
    final args = Get.arguments;
    if (args != null) {
      posmType.value = args['posmType']?['name'] ?? '';
      posmTypeId.value = args['posmType']?['id'] ?? '';
      visualType.value = args['visualType']?['name'] ?? '';
      visualTypeId.value = args['visualType']?['id'] ?? '';
      visibility = args['visibility']; // Assign the passed-in visibility data
    }
  }

  void updateWithArgs({
    Map<String, dynamic>? posmType,
    Map<String, dynamic>? visualType,
    bool isReadOnly = false,
    dynamic visibility,
  }) {
    if (posmType != null) {
      this.posmType.value = posmType['name'] ?? '';
      this.posmTypeId.value = posmType['id'] ?? '';
    }

    if (visualType != null) {
      this.visualType.value = visualType['name'] ?? '';
      this.visualTypeId.value = visualType['id'] ?? '';
    }

    // this.isReadOnly.value = isReadOnly;
    this.visibility = visibility;
  }

  void updateImage(int index, File? file) {
    visibilityImages[index] = file;
    activityController.updateVisibilityImage(index, file);
    update();
  }

  void saveVisibility() {
    final data = {
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
    selectedCondition.value = "";
    isImageUploading.value = [false, false];
    visibilityImages.value = [null, null];
  }
}
