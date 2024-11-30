import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/database/selling_database.dart';
import 'package:cetapil_mobile/model/list_selling_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../api/api.dart';

class SellingController extends GetxController {
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  RxString searchQuery = ''.obs;
  RxList<Data> sellingData = <Data>[].obs;
  final dbHelper = SellingDatabaseHelper.instance;
  final uuid = Uuid();
  
  // Category
  var selectedCategory = 'MT'.obs;
  final List<String> categories = ['GT', 'MT'];
  
  // Loading states
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  
  // Error handling
  RxString errorMessage = ''.obs;

  // Form Controllers
  var outletName = TextEditingController().obs;
  
  // Draft items for products
  RxList<Map<String, dynamic>> draftItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
    checkAndRequestGPS();
  }

  Future<void> checkAndRequestGPS() async {
    if (!gpsController.isGPSEnabled.value) {
      await gpsController.requestGPSActivation();
    }
  }

  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load data from local database (drafted)
      final localData = await dbHelper.getAllSellingData(isDrafted: true);
      
      // Load data from API
      ListSellingResponse apiResponse = await Api.getListSelling();
      List<Data> apiData = apiResponse.data ?? [];
      
      // Mark API data as not drafted
      for (var data in apiData) {
        data.isDrafted = false;
      }
      
      // Mark local data as drafted
      for (var data in localData) {
        data.isDrafted = true;
      }
      
      // Combine both sources and update the list
      sellingData.value = [
        ...localData,
        ...apiData,
      ];
      
    } catch (e) {
      errorMessage.value = 'Gagal memuat data: $e';
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<Data> get filteredSellingData => sellingData.where((data) {
    return data.outletName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
  }).toList();

  Future<void> saveDraftSelling() async {
    try {
      isSaving.value = true;
      
      // Validate required fields
      if (outletName.value.text.isEmpty) {
        throw 'Nama outlet harus diisi';
      }
      
      if (draftItems.isEmpty) {
        throw 'Minimal satu produk harus ditambahkan';
      }

      // Check GPS status
      if (!gpsController.isGPSEnabled.value) {
        bool gpsActivated = await gpsController.requestGPSActivation();
        if (!gpsActivated) {
          throw 'GPS harus diaktifkan untuk menyimpan data';
        }
      }

      if (gpsController.currentPosition.value == null) {
        throw 'Lokasi tidak ditemukan, pastikan GPS aktif';
      }

      // Create products list
      List<Products> products = draftItems.map((item) => Products(
        id: item['id'] ?? uuid.v4(),
        productId: item['product_id'],
        productName: item['sku'],
        stock: int.tryParse(item['stock'].toString()) ?? 0,
        selling: int.tryParse(item['selling'].toString()) ?? 0,
        balance: int.tryParse(item['balance'].toString()) ?? 0,
        price: int.tryParse(item['price'].toString()) ?? 0,
      )).toList();

      // Create selling data
      final data = Data(
        id: uuid.v4(),
        outletName: outletName.value.text,
        products: products,
        longitude: gpsController.currentPosition.value!.longitude.toString(),
        latitude: gpsController.currentPosition.value!.latitude.toString(),
        createdAt: DateTime.now().toIso8601String(),
        isDrafted: true,
      );

      // Save to local database
      await dbHelper.insertSellingData(data, true);
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Draft berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back
      Get.back();
      
      // Refresh the list
      await loadAllData();
      clearForm();

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Future<void> submitSelling(String id) async {
  //   try {
  //     isSaving.value = true;
      
  //     // Get the draft data
  //     final draft = sellingData.firstWhere((element) => element.id == id);
  //     draft.isDrafted = false; // Mark as not draft
      
  //     // Send to API
  //     await Api.createSelling(draft);
      
  //     // Delete from local database
  //     await dbHelper.deleteSellingData(id);
      
  //     // Show success message
  //     Get.snackbar(
  //       'Berhasil',
  //       'Data berhasil dikirim',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );

  //     // Refresh the list
  //     await loadAllData();

  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Gagal mengirim data: $e',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isSaving.value = false;
  //   }
  // }

  Future<void> deleteDraft(String id) async {
    try {
      await dbHelper.deleteSellingData(id);
      await loadAllData();
      Get.snackbar(
        'Success',
        'Draft berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus draft: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add product to draft items
  void addDraftItem(Map<String, dynamic> item) {
    draftItems.add(item);
  }

  // Remove product from draft items
  void removeDraftItem(int index) {
    draftItems.removeAt(index);
  }

  // Clear all draft items
  void clearDraftItems() {
    draftItems.clear();
  }

  Future<void> refreshData() async {
    await loadAllData();
  }

  @override
  void clearForm() {
    outletName.value.clear();
    clearDraftItems();
  }

  @override
  void onClose() {
    outletName.value.dispose();
    super.onClose();
  }
}