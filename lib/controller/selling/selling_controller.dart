import 'dart:io';

import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/database/selling_database.dart';
import 'package:cetapil_mobile/model/list_selling_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../api/api.dart';
import '../../widget/custom_alert.dart';

class SellingController extends GetxController {
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  final SupportDataController supportDataController = Get.find<SupportDataController>();
  RxString searchQuery = ''.obs;
  RxList<Data> sellingData = <Data>[].obs;
  final dbHelper = SellingDatabaseHelper.instance;
  final uuid = Uuid();

  RxString? currentDraftId = RxString('');

  // Category
  var selectedCategory = 'MT'.obs;
  final List<String> categories = ['GT', 'MT'];

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  RxString errorMessage = ''.obs;

  var outletName = TextEditingController().obs;

  // Draft items for products
  RxList<Map<String, dynamic>> draftItems = <Map<String, dynamic>>[].obs;



  Rx<File?> sellingImage = Rx<File?>(null);
  RxBool isImageUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
    checkAndRequestGPS();
  }

  void updateImage(File? newImage) {
    sellingImage.value = newImage;
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

  // Add this method to load draft data for editing
  void loadDraftForEdit(Data draftData) {
    // Clear existing form data
    clearForm();

    // Store the current draft ID
    currentDraftId?.value = draftData.id ?? '';

    // Load the draft data into the form
    outletName.value.text = draftData.outletName ?? '';
    selectedCategory.value = draftData.categoryOutlet ?? 'MT';

    // Load draft items
    draftItems.clear();
    if (draftData.products != null) {
      for (var product in draftData.products!) {
        // Find product in support data to get its category
        final productData = supportDataController.getProducts().firstWhere(
              (p) => p['sku'].toString() == product.productName,
              orElse: () => {
                'category': {'name': 'No Category'},
                'sku': product.productName,
              },
            );

        draftItems.add({
          'id': product.id,
          'product_id': product.productId,
          'sku': product.productName,
          'stock': product.stock,
          'selling': product.selling,
          'balance': product.balance,
          'price': product.price,
          'category': productData['category']['name'] ?? 'No Category',
        });
      }
    }

    print("Attempting to load image from path: ${draftData.image}");
    if (draftData.image != null && draftData.image!.isNotEmpty) {
      try {
        final file = File(draftData.image!);
        print("File exists: ${file.existsSync()}");
        if (file.existsSync()) {
          sellingImage.value = file;
          print("Image loaded successfully");
        } else {
          print('Image file does not exist at path: ${draftData.image}');
        }
      } catch (e) {
        print('Error loading image: $e');
        sellingImage.value = null;
      }
    } else {
      print("No image path provided");
      sellingImage.value = null;
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
      List<Products> products = draftItems
          .map((item) => Products(
                id: item['id'] ?? uuid.v4(),
                productId: item['product_id'],
                productName: item['sku'],
                stock: int.tryParse(item['stock'].toString()) ?? 0,
                selling: int.tryParse(item['selling'].toString()) ?? 0,
                balance: int.tryParse(item['balance'].toString()) ?? 0,
                price: int.tryParse(item['price'].toString()) ?? 0,
              ))
          .toList();

      // Create selling data
      final data = Data(
        // Use existing ID if editing, create new one if new draft
        id: currentDraftId?.value.isNotEmpty == true ? currentDraftId?.value : uuid.v4(),
        outletName: outletName.value.text,
        categoryOutlet: selectedCategory.value,
        products: products,
        longitude: gpsController.currentPosition.value!.longitude.toString(),
        latitude: gpsController.currentPosition.value!.latitude.toString(),
        createdAt: DateTime.now().toIso8601String(),
        isDrafted: true,
        filename: outletName.value.text,
        image: sellingImage.value?.path,
      );

      print("path image ${sellingImage.value!.path}");

      // Update or insert based on whether we're editing
      if (currentDraftId?.value.isNotEmpty == true) {
        // Update existing draft
        await dbHelper.updateSellingData(data, true);
      } else {
        // Insert new draft
        await dbHelper.insertSellingData(data, true);
      }

      // Reset current draft ID
      currentDraftId?.value = '';

      // Navigate back
      Get.back();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Draft berhasil ${currentDraftId?.value.isNotEmpty == true ? 'diperbarui' : 'disimpan'}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

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

  final listProduct = <Map<String, dynamic>>[].obs;

  Future<void> submitApiSelling() async {
    try {
      final String? currentSellingId = Get.arguments?['id'].toString();
      final bool isEditing = currentSellingId != null;
      EasyLoading.show(status: 'Submit Data...');
      final data = {
        'outlet_name': outletName.value.text,
        'category_outlet': selectedCategory.value,
        'longitude': gpsController.currentPosition.value!.longitude.toString(),
        'latitude': gpsController.currentPosition.value!.latitude.toString(),
        'image': sellingImage.value!.path,
      };

      final response = await Api.submitSelling(data, listProduct);

      if (response.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }
print("id draft = $currentDraftId");
      isEditing ? await dbHelper.deleteSellingData(currentDraftId!.value) : null;
      clearForm();
      EasyLoading.dismiss();
      Get.back();
      showSuccessAlert(
          Get.context!, // Use Get.context instead of the previous context
          "Data Berhasil Disimpan",
          "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");
      // await refreshOutlets();
    } catch (e) {
      print('Error submit data: $e');
      Get.snackbar(
        'Error',
        'Failed to submit data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
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
    sellingImage.value = null;
    currentDraftId?.value = ''; // Clear the draft ID when clearing form
  }

  @override
  void onClose() {
    outletName.value.dispose();
    super.onClose();
  }
}
