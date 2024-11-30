import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/list_product_sku_response.dart' as SKU;
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahProdukSellingController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final sellingGetController = Get.find<SellingController>();

  // Selected values using String IDs
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();

  var stockController = TextEditingController().obs;
  var sellingController = TextEditingController().obs;
  var balanceController = TextEditingController().obs;
  var priceController = TextEditingController().obs;

  // Get list of SKUs for selected category
  List<Map<String, dynamic>> get filteredSkus {
    if (selectedCategory.value == null) return [];
    return supportDataController
        .getProducts()
        .where((product) => product['category']['id'].toString() == selectedCategory.value)
        .toList();
  }

  Map<String, dynamic>? get selectedSkuData {
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
    _clearControllers();
  }

  void addProductItems() {
    if (selectedSku.value == null) {
      return;
    }

    // Check if the draftItems already contains an item with the same ID
    final existingItemIndex = sellingGetController.draftItems.indexWhere(
      (item) => item['id'] == selectedSku.value,
    );

    // Define the new product data
    final newItem = {
      'id': selectedSku.value,
      'category': selectedSkuData!['category']['name'],
      'sku': selectedSkuData!['sku'],
      'stock': stockController.value.text,
      'selling': sellingController.value.text,
      'balance': balanceController.value.text,
      'price': priceController.value.text,
    };

    // If the item exists, update it
    if (existingItemIndex != -1) {
      sellingGetController.draftItems[existingItemIndex] = newItem;
    } else {
      // If the item does not exist, add it
      sellingGetController.draftItems.add(newItem);
    }

    // Ensure UI reactivity by refreshing the list (if needed)
    sellingGetController.draftItems.refresh();
  }

  void _clearControllers() {
    stockController.value.clear();
    sellingController.value.clear();
    balanceController.value.clear();
    priceController.value.clear();
  }

  void clearForm() {
    selectedCategory.value = null;
    selectedSku.value = null;
    _clearControllers();
  }
}
