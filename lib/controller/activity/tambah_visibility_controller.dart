import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/activity/tambah_activity_controller.dart';
import '../../controller/support_data_controller.dart';

class TambahVisibilityController extends GetxController {
  late TambahActivityController activityController = Get.find<TambahActivityController>();
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

  initPrimaryVisibilityItem(String id) {
    clearPrimaryForm();
    var data = activityController.visibilityPrimaryDraftItems.firstWhere((item) => item['id'] == id, orElse: () => {});
    if (data.isEmpty) {
      print("posmTypeId.value");
      return;
    } else {
      posmTypeId.value = data['posm_type_id'];
      print(data['posm_type_name']);
      print(posmTypeId.value);
      visualTypeId.value = data['visual_type_id'];
      var visualName = supportDataController
          .getVisualTypes()
          .firstWhere((element) => element['id'] == data['visual_type_id'])['name'];

      /// get visualType name by id
      if (visualName == "Others") {
        isOtherVisual.value = true;
        otherVisualController.value.text = data['visual_type_name'];
      } else {
        visualType.value = data['visual_type_name'];
      }

      selectedCondition.value = data['condition'];
      lebarRak.value.text = data['shelf_width'].toString();
      shelving.value.text = data['shelving'].toString();
      visibilityImages.value = data['image_visibility'];
    }
  }

  initSecondaryVisibilityItem(String id) {
    clearSecondaryForm();
    var data =
        activityController.visibilitySecondaryDraftItems.firstWhere((item) => item['id'] == id, orElse: () => {});
    if (data.isEmpty) {
      return;
    } else {
      toggleSecondaryYesNo.value =
          data['secondary_exist'] == "true" ? true : false;
      tipeDisplay.value.text = data['display_type'];
      displayImages.value = data['display_image'];
    }
  }

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

  void savePrimaryVisibility(String id) {
    if (!validatePrimaryForm()) return;
    var id_part = id.split('-');

    /// (primary, core , 1)
    final data = {
      'id': id,
      'category': id_part[1].toUpperCase(),

      /// (CORE)
      'position': id_part[2],

      /// (1)
      'posm_type_id': posmTypeId.value,
      'posm_type_name': posmType.value,
      'visual_type_id': visualTypeId.value,
      'visual_type_name':
          visualType.value == "Others" ? otherVisualController.value.text : visualType.value,
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

  void saveSecondaryVisibility(String id) {
    if (!validateSecondaryForm()) return;
    var id_part = id.split('-');

    /// (secondaru, core , 1)
    final data = {
      'id': id,
      'category': id_part[1].toUpperCase(),

      /// (CORE)
      'position': id_part[2],

      /// (1)
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
