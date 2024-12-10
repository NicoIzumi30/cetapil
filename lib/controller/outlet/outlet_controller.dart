import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../../api/api.dart';
import '../../controller/gps_controller.dart';
import '../../database/database_instance.dart';
import '../../database/cities.dart';
import '../../model/form_outlet_response.dart';
import '../../model/outlet.dart';
import '../../model/get_city_response.dart';
import '../../utils/image_upload.dart';
import '../../widget/custom_alert.dart';
import '../../model/list_channel_response.dart' as channel;
import '../../page/outlet/tambah_outlet.dart';
import '../../controller/support_data_controller.dart';

class OutletController extends GetxController {
  // SECTION: Dependencies
  final GPSLocationController _gpsController = Get.find<GPSLocationController>();
  final SupportDataController _supportController = Get.find<SupportDataController>();
  final DatabaseHelper _db = DatabaseHelper.instance;
  final CitiesDatabaseHelper _citiesDb = CitiesDatabaseHelper.instance;
  final Uuid _uuid = Uuid();

  // Getters for dependencies
  GPSLocationController get gpsController => _gpsController;
  SupportDataController get supportController => _supportController;
  DatabaseHelper get db => _db;
  CitiesDatabaseHelper get citiesDb => _citiesDb;

  // SECTION: Observable States
  final RxInt listOutletPage = 1.obs;
  final RxList<Outlet> outlets = <Outlet>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'MT'.obs;
  final RxString cityId = ''.obs;
  final RxString cityName = ''.obs;
  final Rxn<Data> selectedCity = Rxn<Data>();
  final Rxn<channel.Data> selectedChannel = Rxn<channel.Data>();

  // Form Controllers
  final Rx<TextEditingController> salesName = TextEditingController().obs;
  final Rx<TextEditingController> outletName = TextEditingController().obs;
  final Rx<TextEditingController> outletAddress = TextEditingController().obs;
  final RxList<TextEditingController> controllers = <TextEditingController>[].obs;

  // Image States
  final RxList<File?> outletImages = RxList([null, null, null]);
  final RxList<String> imageUrls = RxList(['', '', '']);
  final RxList<String> imagePath = RxList(['', '', '']);
  final RxList<String> imageFilename = RxList(['', '', '']);
  final RxList<bool> isImageUploading = RxList([false, false, false]);

  // Constants
  List<String> get categories => ['GT', 'MT'];

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadOutlets();
  }

  // SECTION: Image Handling
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
      CustomAlerts.showError(Get.context!, "Gagal", "Gagal mengupload gambar. Silakan coba lagi.");
    } finally {
      isImageUploading[index] = false;
    }
  }

  Future<File> base64ToFile(String base64String, String fileName) async {
    try {
      if (fileName.isEmpty) {
        throw 'Nama file tidak boleh kosong';
      }

      if (base64String.contains(',')) {
        base64String = base64String.split(',')[1];
      }

      base64String = base64String.trim();
      Uint8List bytes = base64Decode(base64String);
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$fileName';
      File file = await File(filePath).create(recursive: true);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      throw 'Gagal mengkonversi gambar: $e';
    }
  }

  // SECTION: City and Channel Management
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

  void setChannel(channel.Data channel) {
    selectedChannel.value = channel;
  }

  bool validateCity() {
    if (cityId.isEmpty) {
      CustomAlerts.showError(Get.context!, "Validasi", "Silakan pilih kota terlebih dahulu");
      return false;
    }
    return true;
  }

  // SECTION: Data Loading and Sync
  Future<void> loadOutlets() async {
    try {
      isLoading.value = true;
      final results = await _db.getAllOutlets();
      _sortOutlets(results);

      if (results.isEmpty) {
        await refreshOutlets();
      }
    } catch (e) {
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
      print('Error loading outlets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _sortOutlets(List<Outlet> results) {
    results.sort((a, b) {
      if (a.dataSource == 'DRAFT' && b.dataSource != 'DRAFT') return -1;
      if (a.dataSource != 'DRAFT' && b.dataSource == 'DRAFT') return 1;
      return 0;
    });
    outlets.assignAll(results);
  }

  Future<void> refreshOutlets() async {
    try {
      isSyncing.value = true;
      CustomAlerts.showLoading(Get.context!, "Processing", "Mengambil data outlet...");

      final apiResponse = await Api.getOutletList();
      if (apiResponse.status != "OK") {
        throw 'Gagal mendapatkan data dari server';
      }

      await _syncOutlets(apiResponse.data ?? []);
      await loadOutlets();

      CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data outlet berhasil diperbarui");
    } catch (e) {
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal mengambil data: Periksa koneksi Anda dan coba lagi");
    } finally {
      isSyncing.value = false;
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> _syncOutlets(List<Outlet> apiOutlets) async {
    try {
      final localOutlets = await _db.getAllOutlets();

      final Map<String, Outlet> apiOutletMap = {for (var outlet in apiOutlets) outlet.id!: outlet};
      final Map<String, Outlet> localOutletMap = {
        for (var outlet in localOutlets) outlet.id!: outlet
      };

      final List<String> toDelete = [];
      final List<Outlet> toUpsert = [];

      for (final localOutlet in localOutlets) {
        if (localOutlet.dataSource == 'DRAFT') continue;

        final id = localOutlet.id!;
        if (apiOutletMap.containsKey(id)) {
          final apiOutlet = apiOutletMap[id]!;
          if (_hasChanges(localOutlet, apiOutlet)) {
            toUpsert.add(apiOutlet);
          }
        } else if (localOutlet.dataSource == 'API') {
          toDelete.add(id);
        }
      }

      for (final apiOutlet in apiOutlets) {
        if (!localOutletMap.containsKey(apiOutlet.id)) {
          toUpsert.add(apiOutlet);
        }
      }

      if (toDelete.isNotEmpty) await _batchDelete(toDelete);
      if (toUpsert.isNotEmpty) await _batchUpsert(toUpsert);
    } catch (e) {
      print('Error syncing outlets: $e');
      throw 'Failed to sync outlets: $e';
    }
  }

  // SECTION: Submit Operations
  Future<void> submitApiOutlet() async {
    try {
      final String? currentOutletId = Get.arguments?['id'];
      final bool isEditing = currentOutletId != null;

      await _validateSubmission();

      CustomAlerts.showLoading(Get.context!, "Mengirim", "Mengirim data ke server...");

      await _processImages();
      final data = _prepareSubmissionData();
      final questions = _prepareQuestions();

      final response = await Api.submitOutlet(data, questions);

      if (response.status != "OK") {
        throw response.message ?? 'Gagal mengirim data ke server';
      }

      if (isEditing && currentOutletId != null) {
        await _db.deleteOutlet(currentOutletId);
      }

      _handleSubmissionSuccess();
    } catch (e) {
      _handleSubmissionError(e);
    } finally {
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> _validateSubmission() async {
    if (outletName.value.text.isEmpty) {
      throw 'Nama outlet harus diisi';
    }

    if (!_gpsController.isGPSEnabled.value || gpsController.currentPosition.value == null) {
      throw 'Lokasi tidak ditemukan, pastikan GPS aktif';
    }

    if (outletImages.every((image) => image == null)) {
      throw 'Minimal satu gambar harus diupload';
    }

    if (cityName.value.isEmpty || selectedChannel.value == null) {
      throw 'Kota dan channel harus dipilih';
    }
  }

  Future<void> _processImages() async {
    for (int i = 0; i < outletImages.length; i++) {
      if (outletImages[i] != null) {
        await uploadImage(i);
        imagePath[i] = outletImages[i]!.path;
      }
    }
  }

  Map<String, dynamic> _prepareSubmissionData() {
    return {
      'outletName': outletName.value.text,
      'category': selectedCategory.value,
      'city_name': cityName.value,
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
  }

  List<FormOutletResponse> _prepareQuestions() {
    return supportController.getFormOutlet().map((form) {
      return FormOutletResponse(
        id: form['id'] as String,
        type: form['type'] as String,
        question: form['question'] as String,
      );
    }).toList();
  }

  void _handleSubmissionSuccess() {
    clearForm();
    Get.back();

    CustomAlerts.showSuccess(Get.context!, "Data Berhasil Disimpan",
        "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");

    refreshOutlets();
  }

  void _handleSubmissionError(dynamic error) {
    CustomAlerts.showError(
        Get.context!,
        "Gagal",
        error.toString().contains('Exception:')
            ? "Gagal mengirim data ke server. Periksa koneksi Anda dan coba lagi."
            : error.toString());
    print('Error submitting outlet: $error');
  }

  // SECTION: Draft Operations
  Future<void> saveDraftOutlet() async {
    try {
      await _validateDraft();

      CustomAlerts.showLoading(Get.context!, "Menyimpan", "Menyimpan data ke draft...");

      final String? currentOutletId = Get.arguments?['id'];
      final bool isEditing = currentOutletId != null;

      await _processDraftImages();
      final data = _prepareDraftData(currentOutletId, isEditing);
      await _saveDraftToDatabase(data, isEditing);
      await _handleDraftSaveSuccess(isEditing);
    } catch (e) {
      _handleDraftSaveError(e);
    } finally {
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> _validateDraft() async {
    if (outletName.value.text.isEmpty) {
      throw 'Nama outlet harus diisi';
    }

    if (!gpsController.isGPSEnabled.value) {
      bool gpsActivated = await gpsController.requestGPSActivation();
      if (!gpsActivated) {
        throw 'GPS harus diaktifkan untuk menyimpan data';
      }
    }

    if (gpsController.currentPosition.value == null) {
      throw 'Lokasi tidak ditemukan, pastikan GPS aktif';
    }
  }

  Future<void> _processDraftImages() async {
    for (int i = 0; i < outletImages.length; i++) {
      if (outletImages[i] != null) {
        await uploadImage(i);
        imagePath[i] = outletImages[i]!.path;
        imageFilename[i] = path.basename(outletImages[i]!.path);
      }
    }
  }

  Map<String, dynamic> _prepareDraftData(String? currentOutletId, bool isEditing) {
    return {
      'id': isEditing ? currentOutletId : _uuid.v4(),
      'salesName': salesName.value.text,
      'user_name': salesName.value.text,
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
  }

  Future<void> _saveDraftToDatabase(Map<String, dynamic> data, bool isEditing) async {
    if (isEditing) {
      await db.updateOutlet(data: data);
    } else {
      await db.insertOutletWithAnswers(data: data);
    }
    await loadOutlets();
  }

  Future<void> _handleDraftSaveSuccess(bool isEditing) async {
    clearForm();
    Get.back();

    CustomAlerts.showSuccess(
        Get.context!,
        isEditing ? "Draft Berhasil Diperbarui" : "Draft Berhasil Disimpan",
        isEditing
            ? "Anda baru memperbarui Draft. Silahkan periksa status Draft pada aplikasi."
            : "Anda baru menyimpan Draft. Silahkan periksa status Draft pada aplikasi.");
  }

  void _handleDraftSaveError(dynamic error) {
    CustomAlerts.showError(Get.context!, "Gagal", error.toString());
    print('Error saving draft: $error');
  }

  // SECTION: Draft Management
  Future<void> setDraftValue(Outlet outlet) async {
    try {
      // Basic info
      salesName.value.text = outlet.user?.name ?? "";
      outletName.value.text = outlet.name ?? "";
      selectedCategory.value = outlet.category ?? "MT";
      outletAddress.value.text = outlet.address ?? "";

      // City data
      if (outlet.city != null) {
        cityId.value = outlet.city?.id ?? "";
        cityName.value = outlet.city?.name ?? "";
        selectedCity.value = Data(
          id: outlet.city?.id ?? "",
          name: outlet.city?.name ?? "",
        );
      }

      // Channel data
      if (outlet.channel != null) {
        selectedChannel.value = channel.Data(
          id: outlet.channel?.id ?? "",
          name: outlet.channel?.name ?? "",
        );
      }

      // GPS coordinates
      gpsController.longController.value.text = outlet.longitude ?? "";
      gpsController.latController.value.text = outlet.latitude ?? "";

      // Reset and set images
      _resetImages();
      await _loadDraftImages(outlet);

      // Handle form controllers
      _resetFormControllers();
      _loadDraftForms(outlet);

      update();
      Get.to(() => TambahOutlet(), arguments: {'id': outlet.id});
    } catch (e) {
      CustomAlerts.showError(Get.context!, "Gagal", "Gagal memuat draft: $e");
    }
  }

  void _resetImages() {
    outletImages.assignAll([null, null, null]);
    imagePath.assignAll(["", "", ""]);
    imageFilename.assignAll(["", "", ""]);
  }

  Future<void> _loadDraftImages(Outlet outlet) async {
    if (outlet.images != null && outlet.images!.isNotEmpty) {
      for (int i = 0; i < outlet.images!.length; i++) {
        if (i < 3 && outlet.images![i].image != null && outlet.images![i].image!.isNotEmpty) {
          try {
            outletImages[i] = File(outlet.images![i].image!);
            imagePath[i] = outlet.images![i].image!;
            imageFilename[i] = path.basename(outlet.images![i].image!);
          } catch (e) {
            print('Error loading image $i: $e');
          }
        }
      }
    }
  }

  void _resetFormControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    generateControllers();
  }

  void _loadDraftForms(Outlet outlet) {
    if (outlet.forms != null && outlet.forms!.isNotEmpty) {
      for (int i = 0; i < outlet.forms!.length; i++) {
        if (i < controllers.length) {
          controllers[i].text = outlet.forms![i].answer ?? '';
        }
      }
    }
  }

  // SECTION: Utility Methods
  Future<void> deleteDraft(String id) async {
    try {
      await db.deleteOutlet(id);
      await loadOutlets();
      Get.snackbar(
        'Success',
        'Draft berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      CustomAlerts.showError(Get.context!, "Gagal", "Failed to delete draft: $e");
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setListOutletPage(int page) {
    listOutletPage.value = page;
  }

  List<Outlet> get filteredOutlets {
    if (searchQuery.value.isEmpty) {
      return outlets;
    }

    return outlets
        .where((outlet) =>
            outlet.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)
        .toList();
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

  void generateControllers() {
    controllers.assignAll(List.generate(
        supportController.getFormOutlet().length, (index) => TextEditingController()));
  }

  void clearForm() {
    salesName.value.clear();
    outletName.value.clear();
    outletAddress.value.clear();
    cityId.value = '';
    cityName.value = '';
    selectedCity.value = null;
    selectedCategory.value = 'MT';
    selectedChannel.value = null;

    for (var controller in controllers) {
      controller.clear();
    }

    outletImages.assignAll([null, null, null]);
    imagePath.assignAll(["", "", ""]);
    imageFilename.assignAll(["", "", ""]);
    imageUrls.assignAll(['', '', '']);
  }

  Future<void> _batchDelete(List<String> ids) async {
    try {
      const batchSize = 100; // Process in chunks of 100
      for (var i = 0; i < ids.length; i += batchSize) {
        final end = (i + batchSize < ids.length) ? i + batchSize : ids.length;
        final batch = ids.sublist(i, end);

        // Process each batch concurrently
        await Future.wait(batch.map((id) => db.deleteOutlet(id)));
      }
    } catch (e) {
      print('Error in batch delete: $e');
      throw 'Failed to delete outlets: $e';
    }
  }

  Future<void> _batchUpsert(List<Outlet> outlets) async {
    try {
      const batchSize = 100; // Process in chunks of 100
      for (var i = 0; i < outlets.length; i += batchSize) {
        final end = (i + batchSize < outlets.length) ? i + batchSize : outlets.length;
        final batch = outlets.sublist(i, end);

        // Get existing outlets to check draft status and changes
        final existingOutlets =
            await Future.wait(batch.map((outlet) => db.getOutletById(outlet.id!)));

        // Create a list of futures for upsert operations
        final futures = batch.asMap().entries.map((entry) async {
          final index = entry.key;
          final outlet = entry.value;
          final existingOutlet = existingOutlets[index];

          if (existingOutlet == null) {
            // New outlet, insert it
            return db.upsertOutletFromApi(outlet);
          } else if (existingOutlet.dataSource == 'DRAFT') {
            // Don't update drafts
            return null;
          } else if (_hasChanges(existingOutlet, outlet)) {
            // Update only if there are actual changes
            return db.upsertOutletFromApi(outlet);
          }
          return null;
        });

        // Wait for all operations in the batch to complete
        await Future.wait(futures.where((f) => f != null));
      }
    } catch (e) {
      print('Error in batch upsert: $e');
      throw 'Failed to update outlets: $e';
    }
  }

  bool _hasChanges(Outlet local, Outlet api) {
    if (local.dataSource == 'DRAFT') return false;

    return local.name != api.name ||
        local.address != api.address ||
        local.latitude != api.latitude ||
        local.longitude != api.longitude ||
        local.category != api.category ||
        local.visitDay != api.visitDay ||
        local.status != api.status ||
        local.city?.id != api.city?.id ||
        local.city?.name != api.city?.name ||
        local.channel?.id != api.channel?.id ||
        local.channel?.name != api.channel?.name ||
        local.user?.id != api.user?.id ||
        local.user?.name != api.user?.name ||
        _hasImageChanges(local, api) ||
        _hasFormChanges(local, api);
  }

  bool _hasImageChanges(Outlet local, Outlet api) {
    if (local.images?.length != api.images?.length) return true;
    if (local.images != null && api.images != null) {
      for (int i = 0; i < local.images!.length; i++) {
        if (local.images![i].image != api.images![i].image ||
            local.images![i].filename != api.images![i].filename) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasFormChanges(Outlet local, Outlet api) {
    if (local.forms?.length != api.forms?.length) return true;
    if (local.forms != null && api.forms != null) {
      for (int i = 0; i < local.forms!.length; i++) {
        if (local.forms![i].answer != api.forms![i].answer ||
            local.forms![i].outletForm?.id != api.forms![i].outletForm?.id) {
          return true;
        }
      }
    }
    return false;
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
