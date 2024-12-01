import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../model/list_product_sku_response.dart';
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahAvailabilityController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();

  // Selected values
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  final selectedSkuData = Rxn<Map<String, dynamic>>();
  final draftItems = <Map<String, dynamic>>[].obs;

  // Form controllers
  var stockController = TextEditingController().obs;
  var av3mController = TextEditingController().obs;
  var recommendController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    print(activityController.getSelectedChannel());
  }

  // In TambahAvailabilityController
  void editItem(Map<String, dynamic> item) async {
    // Clear previous selections first
    clearForm();

    // Find the category from the product data
    final categories = supportDataController.getCategories();
    final categoryData = categories.firstWhere(
      (cat) => cat['name'] == item['category'],
      orElse: () => <String, dynamic>{}, // Return empty map instead of null
    );

    if (categoryData.isNotEmpty) {
      // Check if map is not empty instead of null check
      // Set category and wait for filteredSkus to update
      selectedCategory.value = categoryData['id'].toString();
      await Future.delayed(const Duration(milliseconds: 100));

      // Find and set SKU
      final skus = filteredSkus;
      final skuData = skus.firstWhere(
        (sku) => sku['id'].toString() == item['id'].toString(),
        orElse: () => <String, dynamic>{}, // Return empty map instead of null
      );

      if (skuData.isNotEmpty) {
        // Check if map is not empty instead of null check
        selectedSku.value = skuData['id'].toString();
        selectedSkuData.value = skuData;

        // Set the form values
        stockController.value.text = item['stock']?.toString() ?? '';
        av3mController.value.text = item['av3m']?.toString() ?? '';
        recommendController.value.text = item['recommend']?.toString() ?? '';
      }
    }
  }

  // Get list of SKUs for selected category
  List<Map<String, dynamic>> get filteredSkus {
    if (selectedCategory.value == null) return [];
    return supportDataController
        .getProducts()
        .where((product) => product['category']['id'].toString() == selectedCategory.value)
        .toList();
  }

  Map<String, dynamic>? get getSelectedSkuData {
    if (selectedSku.value == null) return null;
    return filteredSkus.firstWhere(
      (product) => product['id'].toString() == selectedSku.value,
      orElse: () => {},
    );
  }

  void onCategorySelected(String? categoryId) {
    selectedCategory.value = categoryId;
    selectedSku.value = null;
    _clearControllers();
  }

  void onSkuSelected(String? skuId) {
    selectedSku.value = skuId;
    if (skuId != null) {
      selectedSkuData.value = getSelectedSkuData;

      // Get the outlet's channel from activity controller
      final outletChannel = activityController.getSelectedChannel();

      // Auto-populate AV3M if channel matches
      if (selectedSkuData.value != null &&
          selectedSkuData.value!['channel_av3m'] != null &&
          outletChannel != null) {
        final channelAv3m = selectedSkuData.value!['channel_av3m'] as Map<String, dynamic>;
        final channelValue = channelAv3m[outletChannel];

        if (channelValue != null) {
          av3mController.value.text = channelValue.toString();
        } else {
          av3mController.value.text = '0';
        }
      }
    }
    _clearControllers();
  }

  void addAvailabilityItem() {
    if (selectedSku.value == null || selectedCategory.value == null) return;

    final categoryData = supportDataController
        .getCategories()
        .firstWhere((cat) => cat['id'].toString() == selectedCategory.value);

    // Check for existing item
    final existingItemIndex = draftItems.indexWhere(
      (item) => item['id'] == selectedSku.value,
    );

    // Create new item data
    final newItem = {
      'id': selectedSku.value,
      'category': categoryData['name'],
      'sku': selectedSkuData.value!['sku'],
      'stock': stockController.value.text,
      'av3m': av3mController.value.text,
      'recommend': recommendController.value.text,
    };

    // Update or add item
    if (existingItemIndex != -1) {
      draftItems[existingItemIndex] = newItem;
    } else {
      draftItems.add(newItem);
    }

    // Refresh the list
    draftItems.refresh();
  }

  void _clearControllers() {
    stockController.value.clear();
    // Don't clear av3mController since it's auto-populated
    recommendController.value.clear();
  }

  void clearForm() {
    selectedCategory.value = null;
    selectedSku.value = null;
    selectedSkuData.value = null;
    _clearControllers();
  }

  @override
  void onClose() {
    stockController.value.dispose();
    av3mController.value.dispose();
    recommendController.value.dispose();
    super.onClose();
  }
}
