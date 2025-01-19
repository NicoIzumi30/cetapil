import 'dart:io';
import 'package:cetapil_mobile/database/activity_database.dart';
import 'package:cetapil_mobile/utils/temp_images.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/activity/tambah_activity_controller.dart';
import '../../controller/support_data_controller.dart';

class TambahVisibilityController extends GetxController {
  late TambahActivityController activityController = Get.find<TambahActivityController>();
  final ActivityDatabaseHelper dbHelper = ActivityDatabaseHelper.instance;
  final supportDataController = Get.find<SupportDataController>();
  final _tempImageStorage = TempImageStorage();

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
    var data = activityController.visibilityPrimaryDraftItems
        .firstWhere((item) => item['id'] == id, orElse: () => {});
    if (data.isEmpty) {
      return;
    } else {
      posmTypeId.value = data['posm_type_id'];
      posmType.value = data['posm_type_name'];
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

      print(data['condition']);
      selectedCondition.value = data['condition'];
      lebarRak.value.text = data['shelf_width'].toString();
      shelving.value.text = data['shelving'].toString();
      visibilityImages.value = data['image_visibility'];
    }
  }

  initSecondaryVisibilityItem(String id) {
    clearSecondaryForm();
    var data = activityController.visibilitySecondaryDraftItems
        .firstWhere((item) => item['id'] == id, orElse: () => {});
    if (data.isEmpty) {
      return;
    } else {
      toggleSecondaryYesNo.value = data['secondary_exist'] == "true" ? true : false;
      tipeDisplay.value.text = data['display_type'];
      displayImages.value = data['display_image'];
    }
  }

  initKompetitorVisibilityItem(String id) {
    clearKompetitorForm();
    var data = activityController.visibilityKompetitorDraftItems
        .firstWhere((item) => item['id'] == id, orElse: () => {});
    if (data.isEmpty) {
      return;
    } else {
      brandName.value.text = data['brand_name'];
      promoMechanism.value.text = data['promo_mechanism'];
      selectedDateRange.value = DateTimeRange(
        start: DateTime.parse(data['promo_periode_start']),
        end: DateTime.parse(data['promo_periode_end']),
      );

      programImages1.value = data['program_image1'];
      programImages2.value = data['program_image2'];
    }
  }

  void updateImage(File? file) async {
    try {
      isVisibilityImageUploading.value = true;

      // Delete existing image if any
      if (visibilityImages.value != null) {
        await _tempImageStorage.deleteImage(visibilityImages.value!.path);
      }

      if (file != null) {
        // Check if we're in draft mode by checking if detailOutlet exists in activityController
        final isDraft = activityController.detailOutlet.value != null;

        // Save to temp storage
        final imagePath = await _tempImageStorage.saveImage(
          file,
          category: 'visibility',
          isDraft: isDraft,
        );
        visibilityImages.value = File(imagePath);
      } else {
        visibilityImages.value = null;
      }
    } catch (e) {
      print('Error updating visibility image: $e');
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isVisibilityImageUploading.value = false;
    }
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
    // Add validation for Others visual type
    if (visualTypeId.value.isNotEmpty) {
      final visualTypeData = supportDataController
          .getVisualTypes()
          .firstWhere((element) => element['id'] == visualTypeId.value);
      if (visualTypeData['name'] == "Others" && otherVisualController.value.text.isEmpty) {
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

    // Get the visual type name from support controller using the selected ID
    String visualTypeName = '';
    if (visualTypeId.value.isNotEmpty) {
      final visualTypeData = supportDataController
          .getVisualTypes()
          .firstWhere((element) => element['id'] == visualTypeId.value);
      visualTypeName = visualTypeData['name'];
    }

    final visualTypeValue =
        visualTypeName == "Others" ? otherVisualController.value.text : visualTypeName;

    final data = {
      'id': id,
      'category': id_part[1].toUpperCase(),
      'position': id_part[2],
      'posm_type_id': posmTypeId.value,
      'posm_type_name': posmType.value,
      'visual_type_id': visualTypeId.value,
      'visual_type': visualTypeValue,
      'visual_type_name': visualTypeValue,
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

  /// KOMPETITOR VISIBILITY
  final Rx<TextEditingController> brandName = TextEditingController().obs;
  final Rx<TextEditingController> promoMechanism = TextEditingController().obs;
  final Rx<TextEditingController> promoPeriode = TextEditingController().obs;
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);
  final Rx<File?> programImages1 = Rx<File?>(null);
  final Rx<File?> programImages2 = Rx<File?>(null);
  final isprogramImages1 = false.obs;
  final isprogramImages2 = false.obs;

  void updatedisplayImage(File? file) async {
    try {
      isdisplayImageUploading.value = true;

      // Delete existing image if any
      if (displayImages.value != null) {
        await _tempImageStorage.deleteImage(displayImages.value!.path);
      }

      if (file != null) {
        // Check if we're in draft mode
        final isDraft = activityController.detailOutlet.value != null;

        // Save to temp storage
        final imagePath =
            await _tempImageStorage.saveImage(file, category: 'visibility', isDraft: isDraft);
        displayImages.value = File(imagePath);
      } else {
        displayImages.value = null;
      }
    } catch (e) {
      print('Error updating display image: $e');
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isdisplayImageUploading.value = false;
    }
    update();
  }

  void updatekompetitorImage(File? file, String title) async {
    try {
      if (title == "Foto Program Kompetitor 1") {
        isprogramImages1.value = true;

        // Delete existing image if any
        if (programImages1.value != null) {
          await _tempImageStorage.deleteImage(programImages1.value!.path);
        }

        if (file != null) {
          // Check if we're in draft mode
          final isDraft = activityController.detailOutlet.value != null;

          // Save to temp storage
          final imagePath =
              await _tempImageStorage.saveImage(file, category: 'visibility', isDraft: isDraft);
          programImages1.value = File(imagePath);
        } else {
          programImages1.value = null;
        }
        isprogramImages1.value = false;
      } else {
        isprogramImages2.value = true;

        // Delete existing image if any
        if (programImages2.value != null) {
          await _tempImageStorage.deleteImage(programImages2.value!.path);
        }

        if (file != null) {
          // Check if we're in draft mode
          final isDraft = activityController.detailOutlet.value != null;

          // Save to temp storage
          final imagePath =
              await _tempImageStorage.saveImage(file, category: 'visibility', isDraft: isDraft);
          programImages2.value = File(imagePath);
        } else {
          programImages2.value = null;
        }
        isprogramImages2.value = false;
      }
    } catch (e) {
      print('Error updating kompetitor image: $e');
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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

  bool validateKompetitorForm() {
    List<String> missingFields = [];
    if (brandName.value.text.isEmpty) {
      missingFields.add('Nama Brand');
    }
    if (promoMechanism.value.text.isEmpty) {
      missingFields.add('Mekanisme Promo');
    }
    if (programImages1.value == null) {
      missingFields.add('Foto Program 1');
    }
    if (programImages2.value == null) {
      missingFields.add('Foto Program 2');
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

  Future<void> saveKompetitorVisibility(String id) async {
    if (!validateKompetitorForm()) return;

    var id_part = id.split('-');
    String formattedStart = DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.start);
    String formattedEnd = DateFormat('yyyy-MM-dd').format(selectedDateRange.value!.end);

    final data = {
      'id': id,
      'category': id_part[1].toUpperCase(),
      'position': id_part[2],
      'brand_name': brandName.value.text,
      'promo_mechanism': promoMechanism.value.text,
      'promo_periode_start': formattedStart,
      'promo_periode_end': formattedEnd,
      'program_image1': programImages1.value,
      'program_image2': programImages2.value,
    };

    activityController.addKompetitorVisibilityItem(data);
    clearKompetitorForm();
    Get.back();
  }

  Future<void> loadKompetitorDraft(String id) async {
    try {
      final db = await dbHelper.database;
      final salesActivityId = activityController.detailOutlet.value!.id;
      if (salesActivityId == null) {
        throw Exception('Sales Activity ID is not available');
      }

      final results = await db.query(
        'visibility_kompetitor',
        where: 'id = ? AND sales_activity_id = ?',
        whereArgs: [id, salesActivityId],
        limit: 1,
      );

      if (results.isNotEmpty) {
        final draft = results.first;
        brandName.value.text = draft['brand_name'] as String? ?? '';
        promoMechanism.value.text = draft['promo_mechanism'] as String? ?? '';

        if (draft['promo_periode_start'] != null && draft['promo_periode_end'] != null) {
          selectedDateRange.value = DateTimeRange(
            start: DateTime.parse(draft['promo_periode_start'] as String),
            end: DateTime.parse(draft['promo_periode_end'] as String),
          );
        }

        if (draft['program_image1'] != null) {
          programImages1.value = File(draft['program_image1'] as String);
        }
        if (draft['program_image2'] != null) {
          programImages2.value = File(draft['program_image2'] as String);
        }
      }
    } catch (e) {
      print('Error loading draft: $e');
      Get.snackbar(
        'Error',
        'Failed to load draft',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteKompetitorDraft(String id) async {
    try {
      final db = await dbHelper.database;
      final salesActivityId = activityController.detailOutlet.value!.id;
      if (salesActivityId == null) {
        throw Exception('Sales Activity ID is not available');
      }

      await db.delete(
        'visibility_kompetitor',
        where: 'id = ? AND sales_activity_id = ?',
        whereArgs: [id, salesActivityId],
      );

      // Update UI state
      activityController.visibilityKompetitorDraftItems.removeWhere((item) => item['id'] == id);
      clearKompetitorForm();

      Get.snackbar(
        'Success',
        'Draft deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error deleting draft: $e');
      Get.snackbar(
        'Error',
        'Failed to delete draft',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearKompetitorForm() {
    brandName.value.clear();
    promoMechanism.value.clear();
    promoPeriode.value.clear();
    selectedDateRange.value = null;
    programImages1.value = null;
    programImages2.value = null;
    isprogramImages1.value = false;
    isprogramImages2.value = false;
  }

  @override
  void onClose() {
    _tempImageStorage.cleanupTempCategory('visibility');
    super.onClose();
  }
}
