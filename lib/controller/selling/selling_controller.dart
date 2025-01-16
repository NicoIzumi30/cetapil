import 'dart:async';
import 'dart:io';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/database/selling_database.dart';
import 'package:cetapil_mobile/model/list_selling_response.dart';
import 'package:cetapil_mobile/model/outlet.dart' as O;
import 'package:cetapil_mobile/utils/temp_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../api/api.dart';
import '../../widget/custom_alert.dart';

class SellingController extends GetxController {
  // Dependencies
  final GPSLocationController _gpsController = Get.find<GPSLocationController>();
  final SupportDataController _supportDataController = Get.find<SupportDataController>();
  final OutletController outletController = Get.find<OutletController>();
  final SellingDatabaseHelper _dbHelper = SellingDatabaseHelper.instance;
  final Uuid _uuid = Uuid();

  // Getters for dependencies
  GPSLocationController get gpsController => _gpsController;
  SupportDataController get supportDataController => _supportDataController;
  SellingDatabaseHelper get dbHelper => _dbHelper;

  // Observable states
  final RxString searchQuery = ''.obs;
  final RxList<Data> sellingData = <Data>[].obs;
  final RxString currentDraftId = ''.obs;
  final RxString selectedCategory = 'MT'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<TextEditingController> outletName = TextEditingController().obs;
  final RxList<Map<String, dynamic>> draftItems = <Map<String, dynamic>>[].obs;
  final Rx<File?> sellingImage = Rx<File?>(null);
  final RxBool isImageUploading = false.obs; // Added back the missing property
  final RxList<Map<String, dynamic>> listProduct = <Map<String, dynamic>>[].obs;

  // Category options
  List<String> get categories => ['GT', 'MT'];

  Rx<O.Outlet?> selectedOutlet = Rx<O.Outlet?>(null);
  Rx<String> selectedOutletName = ''.obs;
  RxString searchOutletQuery = ''.obs;

  final duration = 0.obs;
  Timer? _durationTimer;
  final Rx<DateTime> checkedIn = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> checkedOut = Rx<DateTime>(DateTime.now()); // Initialize with current time

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void onOpen() {
    initialize();
    startDurationTimer();
    checkedIn.value = DateTime.now();
  }

  Future<void> _setDraftDuration(Data draftData) async {
    await startDurationTimer();
    duration.value = draftData.duration ?? 0;
  }

  void onReset() {
    duration.value = 0;
    _durationTimer?.cancel();
  }

  Future<void> startDurationTimer() async {
    duration.value = 0;
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration.value++;
      print("Duration: ${duration.value} seconds");
    });
  }

  List<O.Outlet> get filteredOutlets {
    if (searchOutletQuery.value.isEmpty) {
      return outletController.filteredOutletsApproval;
    }
    return outletController.filteredOutletsApproval
        .where((outlet) =>
            outlet.name?.toLowerCase().contains(searchOutletQuery.value.toLowerCase()) ?? false)
        .toList();
  }

  // Method to handle outlet selection
  void setSelectedOutlet(O.Outlet outlet) {
    selectedOutlet.value = outlet;
    selectedOutletName.value = outlet.name ?? '';
    outletName.value.text = outlet.name ?? ''; // Update the outletName TextEditingController
  }

  void setImageUploading(bool value) {
    isImageUploading.value = value;
  }

  void initialize() async {
    await loadInitialData();
    await checkAndRequestGPS();
  }

  // SECTION: GPS Handling
  Future<void> checkAndRequestGPS() async {
    if (!_gpsController.isGPSEnabled.value) {
      await _gpsController.requestGPSActivation();
    }
  }

  Future<void> _validateGPSStatus() async {
    if (!_gpsController.isGPSEnabled.value) {
      bool gpsActivated = await _gpsController.requestGPSActivation();
      if (!gpsActivated) {
        throw 'GPS harus diaktifkan untuk menyimpan data';
      }
    }

    if (_gpsController.currentPosition.value == null) {
      throw 'Lokasi tidak ditemukan, pastikan GPS aktif';
    }
  }

  // SECTION: Data Loading
  Future<void> loadInitialData() async {
    try {
      errorMessage.value = '';
      final localData = await _loadLocalData();
      await _loadAndCombineApiData(localData);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data: $e';
      print('Error loading initial data: $e');
    }
  }

  Future<List<Data>> _loadLocalData() async {
    final localData = await _dbHelper.getAllSellingData(isDrafted: true);
    for (var data in localData) {
      data.isDrafted = true;
    }
    return localData;
  }

  Future<void> _loadAndCombineApiData(List<Data> localData) async {
    try {
      final apiResponse = await Api.getListSelling();
      final apiData = apiResponse.data ?? [];
      for (var data in apiData) {
        data.isDrafted = false;
      }
      sellingData.value = [...localData, ...apiData];
    } catch (e) {
      print('Error loading API data: $e');
      sellingData.value = localData;
      throw e;
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      supportDataController.refreshData();
      CustomAlerts.showLoading(Get.context!, "Processing", "Mengambil data selling...");
      await loadInitialData();
      CustomAlerts.showSuccess(Get.context!, "Berhasil", "Data selling berhasil diperbarui");
    } catch (e) {
      CustomAlerts.showError(
          Get.context!, "Gagal", "Gagal memuat data: Periksa koneksi Anda dan coba lagi");
    } finally {
      isLoading.value = false;
      CustomAlerts.dismissLoading();
    }
  }

  // SECTION: Draft Management
  void loadDraftForEdit(Data draftData) {
    try {
      clearForm();
      _setDraftDuration(draftData);
      _setDraftBasicInfo(draftData);
      _loadDraftProducts(draftData);
      _loadDraftImage(draftData);
    } catch (e) {
      CustomAlerts.showError(Get.context!, "Gagal", "Error loading draft: $e");
    }
  }

  void _setDraftBasicInfo(Data draftData) {
    currentDraftId.value = draftData.id ?? '';
    selectedOutlet.value =
        filteredOutlets.firstWhere((outlet) => outlet.id == draftData.outlet!.id);
    selectedOutletName.value = selectedOutlet.value!.name!;
    selectedCategory.value = selectedOutlet.value!.category!;
  }

  void _loadDraftProducts(Data draftData) {
    draftItems.clear();
    if (draftData.products != null) {
      for (var product in draftData.products!) {
        final productData = _findProductInSupportData(product);
        draftItems.add(_createDraftItemMap(product, productData));
      }
    }
  }

  Map<String, dynamic> _findProductInSupportData(Products product) {
    return _supportDataController.getProducts().firstWhere(
          (p) => p['sku'].toString() == product.productName,
          orElse: () => {
            'category': {'name': 'No Category'},
            'sku': product.productName,
          },
        );
  }

  Map<String, dynamic> _createDraftItemMap(Products product, Map<String, dynamic> productData) {
    return {
      'id': product.id,
      'product_id': product.productId,
      'sku': product.productName,
      'qty': product.qty,
      'price': product.price,
      'category': productData['category']['name'] ?? 'No Category',
    };
  }

  void _loadDraftImage(Data draftData) {
    if (draftData.image?.isNotEmpty == true) {
      try {
        final file = File(draftData.image!);
        sellingImage.value = file.existsSync() ? file : null;
      } catch (e) {
        print('Error loading image: $e');
        sellingImage.value = null;
      }
    } else {
      sellingImage.value = null;
    }
  }

  // SECTION: Save and Submit Operations
  Future<bool> saveDraftSelling() async {
    try {
      isSaving.value = true;
      await _validateDraftData();

      CustomAlerts.showLoading(Get.context!, "Menyimpan", "Menyimpan data ke draft...");
      if (sellingImage.value != null && TempImageStorage().isTempPath(sellingImage.value!.path)) {
        final draftPath =
            await TempImageStorage().moveToTempDraft(sellingImage.value!.path, 'selling');
        sellingImage.value = File(draftPath);
      }

      final data = _prepareDraftData();
      await _saveDraftToDatabase(data);

      _handleDraftSaveSuccess();
      return true;
    } catch (e) {
      CustomAlerts.showError(Get.context!, "Gagal", e.toString());
      return false;
    } finally {
      isSaving.value = false;
      onReset();
      CustomAlerts.dismissLoading();
    }
  }

  Future<void> _validateDraftData() async {
    if (selectedOutlet.value!.name!.isEmpty) {
      throw 'Nama outlet harus diisi';
    }
    if (draftItems.isEmpty) {
      throw 'Minimal satu produk harus ditambahkan';
    }
    await _validateGPSStatus();
  }

  Data _prepareDraftData() {
    return Data(
      id: currentDraftId.value.isNotEmpty ? currentDraftId.value : _uuid.v4(),
      outlet: Outlet(
        id: selectedOutlet.value?.id,
        name: selectedOutlet.value?.name,
      ),
      products: _createProductsList(),
      longitude: _gpsController.currentPosition.value!.longitude.toString(),
      latitude: _gpsController.currentPosition.value!.latitude.toString(),
      createdAt: DateTime.now().toIso8601String(),
      isDrafted: true,
      filename: outletName.value.text,
      image: sellingImage.value?.path,
      checkedIn: checkedIn.value.toString(),
      duration: duration.value,
    );
  }

  Future<void> _saveDraftToDatabase(Data data) async {
    if (currentDraftId.value.isNotEmpty) {
      await _dbHelper.updateSellingData(data, true);
    } else {
      await _dbHelper.insertSellingData(data, true);
    }
  }

  void _handleDraftSaveSuccess() {
    final isUpdating = currentDraftId.value.isNotEmpty;
    CustomAlerts.showSuccess(
        Get.context!,
        isUpdating ? "Draft Berhasil Diperbarui" : "Draft Berhasil Disimpan",
        isUpdating
            ? "Anda baru memperbarui Draft. Silahkan periksa status Draft pada aplikasi."
            : "Anda baru menyimpan Draft. Silahkan periksa status Draft pada aplikasi.");
    loadInitialData();
    clearForm();
  }

  Future<bool> submitApiSelling() async {
    try {
      // Store the draft ID early
      final draftIdToDelete = currentDraftId.value;

      // Validation checks
      if (selectedOutlet.value == null) {
        throw 'Nama outlet harus diisi';
      }

      if (!_gpsController.isGPSEnabled.value || _gpsController.currentPosition.value == null) {
        throw 'Lokasi tidak ditemukan, pastikan GPS aktif';
      }

      // Get and validate image path
      final imagePath = await TempImageStorage().getImagePathForUpload(sellingImage.value?.path);
      if (imagePath == null) {
        throw 'Gambar harus diisi';
      }

      if (draftItems.isEmpty) {
        throw 'Minimal satu produk harus ditambahkan';
      }

      CustomAlerts.showLoading(Get.context!, "Mengirim", "Mengirim data ke server...");
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

      // Prepare request data
      final requestData = {
        'outlet_id': selectedOutlet.value!.id,
        'longitude': _gpsController.currentPosition.value!.longitude.toString(),
        'latitude': _gpsController.currentPosition.value!.latitude.toString(),
        'checked_in': formatter.format(checkedIn.value),
        'checked_out': formatter.format(DateTime.now()),
        'duration': duration.value.toString(),
        'image': imagePath, // Using the validated image path
      };

      // Convert draftItems to listProduct format
      listProduct.clear();
      listProduct.addAll(draftItems);

      final response = await Api.submitSelling(requestData, listProduct);

      if (response.status != "OK") {
        throw 'Gagal mengirim data ke server: ${response.message ?? "Unknown error"}';
      }

      // After successful submission:
      // 1. Delete the image file
      if (imagePath != null) {
        await TempImageStorage().deleteImage(imagePath);
      }

      // 2. Delete the draft if it exists
      if (draftIdToDelete.isNotEmpty) {
        await _dbHelper.deleteSellingData(draftIdToDelete);
      }

      clearForm();
      CustomAlerts.showSuccess(Get.context!, "Data Berhasil Disimpan",
          "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");

      await loadInitialData();
      return true;
    } catch (e) {
      CustomAlerts.dismissLoading();
      CustomAlerts.showError(
          Get.context!,
          "Gagal",
          e.toString().contains('Exception:')
              ? "Gagal mengirim data ke server. Periksa koneksi Anda dan coba lagi."
              : e.toString());
      print('Error submitting data: $e');
      return false;
    } finally {
      onReset();
      CustomAlerts.dismissLoading();
    }
  }

  // SECTION: Draft Items Management
  List<Products> _createProductsList() {
    return draftItems
        .map((item) => Products(
              id: item['id'] ?? _uuid.v4(),
              productId: item['product_id'],
              productName: item['sku'],
              qty: int.tryParse(item['qty'].toString()) ?? 0,
              price: int.tryParse(item['price'].toString()) ?? 0,
            ))
        .toList();
  }

  void addDraftItem(Map<String, dynamic> item) {
    draftItems.add(item);
  }

  void removeDraftItem(int index) {
    draftItems.removeAt(index);
  }

  void clearDraftItems() {
    draftItems.clear();
  }

  // SECTION: Utility Methods
  Future<void> deleteDraft(String id) async {
    try {
      await _dbHelper.deleteSellingData(id);
      await loadInitialData();
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

  void updateImage(File? newImage) async {
    try {
      setImageUploading(true);

      if (sellingImage.value != null && newImage == null) {
        // If we're deleting the image
        await TempImageStorage().deleteImage(sellingImage.value!.path);
        sellingImage.value = null;
      } else if (newImage != null) {
        // If there's an existing image, delete it first
        if (sellingImage.value != null) {
          await TempImageStorage().deleteImage(sellingImage.value!.path);
        }

        // Save the new image
        final imagePath = await TempImageStorage()
            .saveImage(newImage, category: 'selling', isDraft: currentDraftId.value.isNotEmpty);
        sellingImage.value = File(imagePath);
      }
    } catch (e) {
      print('Error updating image: $e');
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setImageUploading(false);
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<Data> get filteredSellingData => sellingData.where((data) {
        return data.outlet?.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
      }).toList();

  void clearForm() async {
    selectedOutletName.value = '';
    clearDraftItems();

    // Delete the temporary image if it exists
    if (sellingImage.value != null) {
      TempImageStorage().cleanupTempCategory('selling');
      sellingImage.value = null;
    }

    currentDraftId.value = '';
  }

  @override
  void onClose() {
    TempImageStorage().cleanupTempCategory('selling');
    outletName.value.dispose();
    _durationTimer?.cancel();
    super.onClose();
  }
}
