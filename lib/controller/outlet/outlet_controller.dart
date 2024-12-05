import 'dart:convert';
import 'dart:io';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/database/database_instance.dart';
import 'package:cetapil_mobile/database/cities.dart';
import 'package:cetapil_mobile/model/form_outlet_response.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/model/get_city_response.dart';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:cetapil_mobile/widget/custom_alert.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../../model/list_channel_response.dart' as channel;
import '../../page/outlet/tambah_outlet.dart';
import '../support_data_controller.dart';

class OutletController extends GetxController {
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  final SupportDataController supportController = Get.find<SupportDataController>();
  final api = Api();
  final db = DatabaseHelper.instance;
  final citiesDb = CitiesDatabaseHelper.instance;
  final uuid = Uuid();
  var selectedCategory = 'MT'.obs;

  final RxInt listOutletPage = 1.obs;
  final List<String> categories = ['GT', 'MT'];

  // Observables
  var outlets = <Outlet>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  RxString searchQuery = ''.obs;

  // Form Controllers
  var salesName = TextEditingController().obs;
  var outletName = TextEditingController().obs;
  var outletAddress = TextEditingController().obs;
  var selectedChannel = Rxn<channel.Data>();
  var controllers = <TextEditingController>[].obs;
  // var questions = <FormOutletResponse>[].obs;

  setListOutletPage(int page) {
    if (listOutletPage.value != page) {
      listOutletPage.value = page;
    }
  }

  // Add this method in the OutletController class
  void setChannel(channel.Data channel) {
    selectedChannel.value = channel;
  }

  setDraftValue(Outlet outlet) async {
    // Set sales name - Make sure to properly set value
    print("Setting sales name: ${outlet.user?.name}"); // Debug print
    salesName.value.text = outlet.user?.name ?? "";

    // Set outlet name
    outletName.value.text = outlet.name ?? "";

    // Set category
    selectedCategory.value = outlet.category ?? "MT";

    // Set city data - Make sure these values are set
    print("Setting city data: ${outlet.city?.id}, ${outlet.city?.name}"); // Debug print
    cityId.value = outlet.city?.id ?? "";
    cityName.value = outlet.city?.name ?? "";
    if (outlet.city != null) {
      selectedCity.value = Data(
        id: outlet.city?.id ?? "",
        name: outlet.city?.name ?? "",
      );
    }

    if (outlet.channel != null) {
      selectedChannel.value = channel.Data(
        id: outlet.channel?.id ?? "",
        name: outlet.channel?.name ?? "",
      );
    }

    // Set address
    outletAddress.value.text = outlet.address ?? "";

    // Set GPS coordinates
    gpsController.longController.value.text = outlet.longitude ?? "";
    gpsController.latController.value.text = outlet.latitude ?? "";

    // Reset and set images
    outletImages.assignAll([null, null, null]);
    imagePath.assignAll(["", "", ""]);
    imageFilename.assignAll(["", "", ""]);

    // Safely set images if they exist
    if (outlet.images != null && outlet.images!.isNotEmpty) {
      for (int i = 0; i < outlet.images!.length; i++) {
        if (i < 3 && outlet.images![i].image != null && outlet.images![i].image!.isNotEmpty) {
          try {
            outletImages[i] = File(outlet.images![i].image!);
            imagePath[i] = outlet.images![i].image!;
            imageFilename[i] = path.basename(outlet.images![i].image!);
          } catch (e) {
            print('Error loading image $i: $e');
            outletImages[i] = null;
            imagePath[i] = "";
            imageFilename[i] = "";
          }
        }
      }
    }

    // Reset controllers first
    for (var controller in controllers) {
      controller.text = "";
    }

    generateControllers(); // Generate new controllers

    // Safely set form answers
    if (outlet.forms != null && outlet.forms!.isNotEmpty) {
      for (int i = 0; i < outlet.forms!.length; i++) {
        if (i < controllers.length) {
          controllers[i].text = outlet.forms![i].answer ?? '';
        }
      }
    }

    // Force update the UI
    update();

    // Navigate with the ID
    Get.to(() => TambahOutlet(), arguments: {'id': outlet.id});
  }

  Future<File> base64ToFile(String base64String, String fileName) async {
    try {
      // Ensure fileName is not empty
      if (fileName.isEmpty) {
        throw Exception('File name cannot be empty');
      }

      // Remove any "data:image/*;base64," prefix if present
      if (base64String.contains(',')) {
        base64String = base64String.split(',')[1];
      }

      // Remove any whitespace
      base64String = base64String.trim();

      Uint8List bytes = base64Decode(base64String);

      // Get the temporary directory of the device
      Directory tempDir = await getTemporaryDirectory();

      // Create a file path with the desired file name
      String filePath = '${tempDir.path}/$fileName';

      // Create the file and write bytes
      File file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      throw Exception('Failed to convert base64 to file: $e');
    }
  }

  // City Related
  var cityId = RxString('');
  var cityName = RxString('');
  var selectedCity = Rxn<Data>();

  // Image Controllers
  final RxList<File?> outletImages = RxList([null, null, null]); // [frontView, banner, landmark]
  final RxList<String> imageUrls = RxList(['', '', '']);
  final RxList<String> imagePath = RxList(['', '', '']);
  final RxList<String> imageFilename = RxList(['', '', '']);
  final RxList<bool> isImageUploading = RxList([false, false, false]);

  @override
  void onInit() {
    super.onInit();
    // initializeFormData();
    loadOutlets(); // Only load from SQLite initially
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

  // New method for manual refresh
  Future<void> refreshOutlets() async {
    try {
      isSyncing.value = true;
      CustomAlerts.showLoading(
          Get.context!, // Use Get.context instead of the previous context
          "Processing",
          "Mengambil data outlet...");

      final apiResponse = await Api.getOutletList();
      if (apiResponse.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }

      final apiOutlets = apiResponse.data ?? [];
      final localOutlets = await db.getAllOutlets();

      // Create maps for efficient lookup
      final Map<String, Outlet> apiOutletMap = {for (var outlet in apiOutlets) outlet.id!: outlet};
      final Map<String, Outlet> localOutletMap = {
        for (var outlet in localOutlets) outlet.id!: outlet
      };

      final List<Future> operations = [];
      final List<String> toDelete = [];
      final List<Outlet> toUpsert = [];

      // Handle existing outlets
      for (final localOutlet in localOutlets) {
        final id = localOutlet.id!;

        // Skip if it's a draft
        if (localOutlet.dataSource == 'DRAFT') {
          continue;
        }

        if (apiOutletMap.containsKey(id)) {
          final apiOutlet = apiOutletMap[id]!;
          if (_hasChanges(localOutlet, apiOutlet)) {
            toUpsert.add(apiOutlet);
          }
        } else if (localOutlet.dataSource == 'API') {
          toDelete.add(id);
        }
      }

      // Add new outlets from API
      for (final apiOutlet in apiOutlets) {
        if (!localOutletMap.containsKey(apiOutlet.id)) {
          toUpsert.add(apiOutlet);
        }
      }

      // Execute operations
      if (toDelete.isNotEmpty) {
        await _batchDelete(toDelete);
      }

      if (toUpsert.isNotEmpty) {
        await _batchUpsert(toUpsert);
      }

      await loadOutlets();

      CustomAlerts.dismissLoading();
      CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data outlet berhasil diperbarui");
    } catch (e) {
      print('Error syncing outlets: $e');
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    } finally {
      isSyncing.value = false;
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> loadOutlets() async {
    try {
      isLoading.value = true;
      final results = await db.getAllOutlets();

      // Simple sort - drafts always on top
      results.sort((a, b) {
        if (a.dataSource == 'DRAFT' && b.dataSource != 'DRAFT') {
          return -1;
        }
        if (a.dataSource != 'DRAFT' && b.dataSource == 'DRAFT') {
          return 1;
        }
        return 0; // Keep original order for same type
      });

      outlets.assignAll(results);
    } catch (e) {
      print('Error loading outlets: $e');
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> initializeFormData() async {
  //   try {
  //     isLoading.value = true;
  //     final isEmpty = await db.isOutletFormsEmpty();
  //
  //     if (isEmpty) {
  //       final response = await Api.getFormOutlet();
  //       if (response == null || response.isEmpty) {
  //         throw Exception('Failed to load forms: Empty response');
  //       }
  //       try {
  //         await db.insertOutletFormBatch(response);
  //       } catch (e) {
  //         throw Exception('Failed to insert forms: $e');
  //       }
  //     }
  //
  //     final forms = await db.getAllForms();
  //     if (forms.isEmpty) {
  //       throw Exception('No forms found in database');
  //     }
  //
  //     questions.value = forms
  //         .map((form) => FormOutletResponse(
  //               id: form['id'] as String,
  //               type: form['type'] as String,
  //               question: form['question'] as String,
  //             ))
  //         .toList();
  //
  //     generateControllers();
  //   } catch (e) {
  //     print('Error initializing form data: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> saveDraftOutlet() async {
    try {
      CustomAlerts.showLoading(Get.context!, "Menyimpan", "Menyimpan data ke draft...");

      final String? currentOutletId = Get.arguments?['id'];
      final bool isEditing = currentOutletId != null;

      for (int i = 0; i < outletImages.length; i++) {
        if (outletImages[i] != null) {
          await uploadImage(i);
          imagePath[i] = outletImages[i]!.path;
          imageFilename[i] = path.basename(outletImages[i]!.path);
        }
      }

      final data = {
        'id': isEditing ? currentOutletId : uuid.v4(),
        'salesName': salesName.value.text,
        'user_name': salesName.value.text, // Add this duplicate field
        'outletName': outletName.value.text,
        'category': selectedCategory.value,
        'channel': json.encode({
          'id': selectedChannel.value?.id ?? "",
          'name': selectedChannel.value?.name ?? "",
        }),
        'city_id': cityId.value.isEmpty ? "" : cityId.value,
        'city_name': cityName.value.isEmpty ? "" : cityName.value,
        'longitude': gpsController.longController.value.text,
        'latitude': gpsController.latController.value.text,
        'address': outletAddress.value.text,
        'status': 'PENDING',
        'data_source': 'DRAFT',
        'is_synced': 0,
        'image_front': imageUrls[0],
        'image_banner': imageUrls[1],
        'image_landmark': imageUrls[2],
        'filename_1': imageFilename[0],
        'filename_2': imageFilename[1],
        'filename_3': imageFilename[2],
        'image_path_1': imagePath[0],
        'image_path_2': imagePath[1],
        'image_path_3': imagePath[2],
        for (int i = 0; i < supportController.getFormOutlet().length; i++)
          'form_id_${supportController.getFormOutlet()[i]['id']}': controllers[i].value.text,
        'created_at': isEditing ? null : DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (isEditing) {
        await db.updateOutlet(data: data);
      } else {
        await db.insertOutletWithAnswers(data: data);
      }

      await loadOutlets();
      clearForm();

      // Navigate back first
      CustomAlerts.dismissLoading();
      Get.back();

      // Then show the success alert
      CustomAlerts.showSuccess(
          Get.context!,
          isEditing ? "Draft Berhasil Diperbarui" : "Draft Berhasil Disimpan",
          isEditing
              ? "Anda baru memperbarui Draft. Silahkan periksa status Draft pada aplikasi."
              : "Anda baru menyimpan Draft. Silahkan periksa status Draft pada aplikasi.");
    } catch (e) {
      print('Error saving draft: $e');
      CustomAlerts.showError(Get.context!, "Gagal", "Gagal menyimpan data ke draft.");
    } finally {
      CustomAlerts.dismissLoading();
      EasyLoading.dismiss();
    }
  }

  Future<void> submitApiOutlet() async {
    try {
      final String? currentOutletId = Get.arguments?['id'];
      final bool isEditing = currentOutletId != null;

      CustomAlerts.showLoading(Get.context!, "Mengirim", "Mengirim data ke server...");

      for (int i = 0; i < outletImages.length; i++) {
        if (outletImages[i] != null) {
          await uploadImage(i);
          imagePath[i] = outletImages[i]!.path;
        }
      }
      final data = {
        'outletName': outletName.value.text,
        'category': selectedCategory.value,
        'city_name': cityName.value.isEmpty ? "" : cityName.value,
        'channel_id': selectedChannel.value?.id,
        'visit_day': DateTime.now().weekday.toString(),
        'longitude': gpsController.longController.value.text,
        'latitude': gpsController.latController.value.text,
        'address': outletAddress.value.text,
        'cycle': "1x1",
        'image_path_1': imagePath[0],
        'image_path_2': imagePath[1],
        'image_path_3': imagePath[2],
        for (int i = 0; i < supportController.getFormOutlet().length; i++)
          'forms[$i][id]': supportController.getFormOutlet()[i]['id'],
        for (int i = 0; i < supportController.getFormOutlet().length; i++)
          'forms[$i][answer]': controllers[i].value.text,
      };
      List<FormOutletResponse> questions = supportController.getFormOutlet().map((form) {
        return FormOutletResponse(
          id: form['id'] as String,
          type: form['type'] as String,
          question: form['question'] as String,
        );
      }).toList();
      final response = await Api.submitOutlet(data, questions);

      if (response.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }

      isEditing ? await db.deleteOutlet(currentOutletId) : null;
      clearForm();
      CustomAlerts.dismissLoading();
      Get.back();

      CustomAlerts.showSuccess(
          Get.context!, // Use Get.context instead of the previous context
          "Data Berhasil Disimpan",
          "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");
      await refreshOutlets();
    } catch (e) {
      print('Error submit data: $e');
      CustomAlerts.showError(Get.context!, "Gagal",
          "Gagal mengirim data ke server : Periksa koneksi Anda dan coba lagi");
    } finally {
      CustomAlerts.dismissLoading();
    }
  }

  void clearForm() {
    salesName.value.clear();
    outletName.value.clear();
    outletAddress.value.clear();
    cityId.value = '';
    cityName.value = '';
    selectedCity.value = null;
    selectedCategory.value = 'MT'; // Reset to default MT
    selectedChannel.value = null;
    for (var controller in controllers) {
      controller.clear();
    }
    outletImages.assignAll([null, null, null]);
    imagePath.assignAll(["", "", ""]);
    imageFilename.assignAll(["", "", ""]);
    imageUrls.assignAll(['', '', '']);
  }

  List<Outlet> get filteredOutlets {
    if (searchQuery.value.isEmpty) {
      return outlets
          .where((outlet) => outlet.dataSource == 'DRAFT' || outlet.dataSource == 'API')
          .toList();
    }

    final filtered = outlets
        .where((outlet) =>
            (outlet.dataSource == 'DRAFT' || outlet.dataSource == 'API') &&
            (outlet.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false))
        .toList();

    // Keep drafts at top in filtered results
    filtered.sort((a, b) {
      if (a.dataSource == 'DRAFT' && b.dataSource != 'DRAFT') {
        return -1;
      }
      if (a.dataSource != 'DRAFT' && b.dataSource == 'DRAFT') {
        return 1;
      }
      return 0;
    });

    return filtered;
  }

  List<Outlet> get filteredOutletsApproval {
    if (searchQuery.value.isEmpty) {
      return outlets
          .where((outlet) => outlet.dataSource == 'API' && outlet.status == 'APPROVED')
          .toList();
    }

    return outlets
        .where((outlet) =>
            outlet.dataSource == 'API' &&
            outlet.status == 'APPROVED' &&
            (outlet.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false))
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void generateControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.assignAll(List.generate(
        supportController.getFormOutlet().length, (index) => TextEditingController()));
  }

  // Helper methods for batch operations
  Future<void> _batchDelete(List<String> ids) async {
    const batchSize = 100;
    for (var i = 0; i < ids.length; i += batchSize) {
      final end = (i + batchSize < ids.length) ? i + batchSize : ids.length;
      final batch = ids.sublist(i, end);
      await Future.wait(batch.map((id) => db.deleteOutlet(id)));
    }
  }

  Future<void> _batchUpsert(List<Outlet> outlets) async {
    const batchSize = 100;
    for (var i = 0; i < outlets.length; i += batchSize) {
      final end = (i + batchSize < outlets.length) ? i + batchSize : outlets.length;
      final batch = outlets.sublist(i, end);

      // Get existing outlets to check draft status
      final existingOutlets =
          await Future.wait(batch.map((outlet) => db.getOutletById(outlet.id!)));

      // Create a list of futures for upsert operations
      final futures = batch.asMap().entries.map((entry) {
        final index = entry.key;
        final outlet = entry.value;

        // If the existing outlet is a draft, preserve its draft status
        if (existingOutlets[index]?.dataSource == 'DRAFT') {
          final modifiedOutlet = Outlet(
              id: outlet.id,
              name: outlet.name,
              address: outlet.address,
              latitude: outlet.latitude,
              longitude: outlet.longitude,
              category: outlet.category,
              channel: Channel(
                id: outlet.channel?.id,
                name: outlet.channel?.name,
              ),
              city: outlet.city, // Use the city object directly
              images: outlet.images,
              forms: outlet.forms,
              user: outlet.user,
              dataSource: 'DRAFT', // Preserve draft status
              status: outlet.status,
              visitDay: outlet.visitDay,
              weekType: outlet.weekType,
              cycle: outlet.cycle,
              salesActivity: outlet.salesActivity,
              isSynced: false);
          return db.upsertOutletFromApi(modifiedOutlet);
        }

        return db.upsertOutletFromApi(outlet);
      });

      await Future.wait(futures);
    }
  }

  Future<void> _syncDrafts(List<Outlet> drafts) async {
    await Future.wait(drafts.map((draft) => Future(() async {
          try {
            await db.markOutletAsSynced(draft.id!);
            return true; // Return a value to satisfy the Future type
          } catch (e) {
            print('Failed to sync draft outlet ${draft.id}: $e');
            return false; // Return a value even in case of error
          }
        })));
  }

// Also update the _hasChanges method
  bool _hasChanges(Outlet local, Outlet api) {
    // Always skip sync for drafts
    if (local.dataSource == 'DRAFT') {
      return false;
    }

    return local.name != api.name ||
        local.address != api.address ||
        local.latitude != api.latitude ||
        local.longitude != api.longitude ||
        local.city?.id != api.city?.id ||
        local.city?.name != api.city?.name ||
        local.category != api.category ||
        local.channel?.id != api.channel?.id || // Add channel comparison
        local.channel?.name != api.channel?.name;
  }

  @override
  void onClose() {
    salesName.value.dispose();
    outletName.value.dispose();
    outletAddress.value.dispose();
    selectedChannel.value = null;
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
