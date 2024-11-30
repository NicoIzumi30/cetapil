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
    if (selectedSku.value == null) return;

    // Check for existing item
    final existingItemIndex = draftItems.indexWhere(
      (item) => item['id'] == selectedSku.value,
    );

    // Create new item data
    final newItem = {
      'id': selectedSku.value,
      'category': getSelectedSkuData!['category']['name'],
      'sku': getSelectedSkuData!['sku'],
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
