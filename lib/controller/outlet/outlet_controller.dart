import 'dart:io';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/database/database_instance.dart';
import 'package:cetapil_mobile/database/cities.dart';
import 'package:cetapil_mobile/model/form_outlet_response.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/model/get_city_response.dart';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class OutletController extends GetxController {
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  final api = Api();
  final db = DatabaseHelper.instance;
  final citiesDb = CitiesDatabaseHelper.instance;
  final uuid = Uuid();

  // Observables
  var outlets = <Outlet>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  RxString searchQuery = ''.obs;

  // Form Controllers
  var salesName = TextEditingController().obs;
  var outletName = TextEditingController().obs;
  var outletAddress = TextEditingController().obs;
  var controllers = <TextEditingController>[].obs;
  var questions = <FormOutletResponse>[].obs;

  // City Related
  var cityId = RxString('');
  var cityName = RxString('');
  var selectedCity = Rxn<Data>();

  // Image Controllers
  final RxList<File?> outletImages = RxList([null, null, null]); // [frontView, banner, landmark]
  final RxList<String> imageUrls = RxList(['', '', '']);
  final RxList<bool> isImageUploading = RxList([false, false, false]);

  @override
  void onInit() {
    super.onInit();
    initializeFormData();
    syncOutlets();
  }

  // City related methods
  void setCity(Data? city) {
    if (city != null) {
      cityId.value = city.id ?? '';
      cityName.value = city.name ?? '';
      selectedCity.value = city;
    } else {
      cityId.value = '';
      cityName.value = '';
      selectedCity.value = null;
    }
  }

  bool validateCity() {
    if (cityId.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select a city',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return false;
    }
    return true;
  }

  void updateImage(int index, File? file) {
    outletImages[index] = file;
    update();
  }

  Future<void> uploadImage(int index) async {
    if (outletImages[index] == null) return;

    try {
      isImageUploading[index] = true;

      final base64Image = await ImageUploadUtils.convertImageToBase64(outletImages[index]!);

      if (base64Image != null) {
        imageUrls[index] = base64Image;
      }
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isImageUploading[index] = false;
    }
  }

  Future<void> syncOutlets() async {
    try {
      isSyncing.value = true;
      EasyLoading.show(status: 'Syncing data...');

      final apiResponse = await Api.getOutletList();
      if (apiResponse.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }

      final apiOutlets = apiResponse.data ?? [];
      final localOutlets = await db.getAllOutlets();
      final apiIds = apiOutlets.map((o) => o.id).toSet();
      final localIds = localOutlets.map((o) => o.id).toSet();
      final idsToAdd = apiIds.difference(localIds);
      final idsToUpdate = apiIds.intersection(localIds);
      final idsToDelete = localIds
          .difference(apiIds)
          .where((id) => localOutlets.firstWhere((o) => o.id == id).dataSource == 'API');

      for (var id in idsToDelete) {
        await db.deleteOutlet(id!);
      }

      for (var outlet in apiOutlets) {
        if (idsToAdd.contains(outlet.id) || idsToUpdate.contains(outlet.id)) {
          await db.upsertOutletFromApi(outlet);
        }
      }

      final drafts = await db.getUnsyncedDraftOutlets();
      for (var draft in drafts) {
        try {
          await db.markOutletAsSynced(draft.id!);
        } catch (e) {
          print('Failed to sync draft outlet ${draft.id}: $e');
        }
      }

      await loadOutlets();

      Get.snackbar(
        'Sync Complete',
        'Outlets have been synchronized successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error syncing outlets: $e');
      Get.snackbar(
        'Sync Error',
        'Failed to sync outlets: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> loadOutlets() async {
    try {
      isLoading.value = true;
      final results = await db.getAllOutlets();
      outlets.assignAll(results);
    } catch (e) {
      print('Error loading outlets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializeFormData() async {
    try {
      isLoading.value = true;

      final isEmpty = await db.isOutletFormsEmpty();

      if (isEmpty) {
        final response = await Api.getFormOutlet();
        if (response.isNotEmpty) {
          await db.insertOutletFormBatch(response);
        }
      }

      final forms = await db.getAllForms();
      questions.value = forms
          .map((form) => FormOutletResponse(
                id: form['id'] as String,
                type: form['type'] as String,
                question: form['question'] as String,
              ))
          .toList();

      generateControllers();
    } catch (e) {
      print('Error initializing form data: $e');
      Get.snackbar(
        'Error',
        'Failed to load form data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDraftOutlet() async {
    try {
      if (!validateCity()) return;
      
      EasyLoading.show(status: 'Saving draft...');

      for (int i = 0; i < outletImages.length; i++) {
        if (outletImages[i] != null) {
          await uploadImage(i);
        }
      }

      final data = {
        'id': uuid.v4(),
        'salesName': salesName.value.text,
        'outletName': outletName.value.text,
        'category': 'MT',
        'city_id': cityId.value,
        'city_name': cityName.value,
        'longitude': gpsController.longController.value.text,
        'latitude': gpsController.latController.value.text,
        'address': outletAddress.value.text,
        'status': 'PENDING',
        'data_source': 'DRAFT',
        'is_synced': 0,

        'image_front': imageUrls[0],
        'image_banner': imageUrls[1],
        'image_landmark': imageUrls[2],

        for (int i = 0; i < questions.length; i++)
          'form_id_${questions[i].id}': controllers[i].value.text,

        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await db.insertOutletWithAnswers(data: data);
      await loadOutlets();

      Get.snackbar(
        'Success',
        'Draft saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    } catch (e) {
      print('Error saving draft: $e');
      Get.snackbar(
        'Error',
        'Failed to save draft: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearForm() {
    salesName.value.clear();
    outletName.value.clear();
    outletAddress.value.clear();
    cityId.value = '';
    cityName.value = '';
    selectedCity.value = null;
    for (var controller in controllers) {
      controller.clear();
    }
    outletImages.assignAll([null, null, null]);
    imageUrls.assignAll(['', '', '']);
  }

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
        return outlet.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
      }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void generateControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.assignAll(List.generate(questions.length, (index) => TextEditingController()));
  }

  @override
  void onClose() {
    salesName.value.dispose();
    outletName.value.dispose();
    outletAddress.value.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}