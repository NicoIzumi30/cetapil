import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/support_data_controller.dart';

class TambahOrderController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();

  // Selected values
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  final selectedSkuData = Rxn<Map<String, dynamic>>();
  final draftItems = <Map<String, dynamic>>[].obs;

  // Form controllers
  var jumlahController = TextEditingController().obs;
  var hargaController = TextEditingController().obs;

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
    }
    _clearControllers();
  }

  void editItem(Map<String, dynamic> item) async {
    clearForm();

    final categories = supportDataController.getCategories();
    final categoryData = categories.firstWhere(
      (cat) => cat['name'] == item['category'],
      orElse: () => <String, dynamic>{},
    );

    if (categoryData.isNotEmpty) {
      selectedCategory.value = categoryData['id'].toString();
      await Future.delayed(const Duration(milliseconds: 100));

      final skus = filteredSkus;
      final skuData = skus.firstWhere(
        (sku) => sku['id'].toString() == item['id'].toString(),
        orElse: () => <String, dynamic>{},
      );

      if (skuData.isNotEmpty) {
        selectedSku.value = skuData['id'].toString();
        selectedSkuData.value = skuData;

        jumlahController.value.text = item['jumlah']?.toString() ?? '';
        hargaController.value.text = item['harga']?.toString() ?? '';
      }
    }
  }

  void addOrderItem() {
    if (selectedSku.value == null || selectedCategory.value == null) return;

    final categoryData = supportDataController
        .getCategories()
        .firstWhere((cat) => cat['id'].toString() == selectedCategory.value);

    final existingItemIndex = draftItems.indexWhere(
      (item) => item['id'] == selectedSku.value,
    );

    final newItem = {
      'id': selectedSku.value,
      'category': categoryData['name'],
      'sku': selectedSkuData.value!['sku'],
      'jumlah': jumlahController.value.text,
      'harga': hargaController.value.text,
    };

    if (existingItemIndex != -1) {
      draftItems[existingItemIndex] = newItem;
    } else {
      draftItems.add(newItem);
    }

    draftItems.refresh();
  }

  void _clearControllers() {
    jumlahController.value.clear();
    hargaController.value.clear();
  }

  void clearForm() {
    selectedCategory.value = null;
    selectedSku.value = null;
    selectedSkuData.value = null;
    _clearControllers();
  }

  @override
  void onClose() {
    jumlahController.value.dispose();
    hargaController.value.dispose();
    super.onClose();
  }
}
