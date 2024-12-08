// tambah_availability_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/support_data_controller.dart';
import '../../controller/activity/tambah_activity_controller.dart';

class TambahAvailabilityController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();

  // Selected values
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  final selectedSkuData = Rxn<Map<String, dynamic>>();

  // Form controllers
  var stockController = TextEditingController().obs;
  var av3mController = TextEditingController().obs;
  var recommendController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
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

        stockController.value.text = item['stock']?.toString() ?? '';
        av3mController.value.text = item['av3m']?.toString() ?? '';
        recommendController.value.text = item['recommend']?.toString() ?? '';
      }
    }
  }

  ///GET SKU by id Category
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

  List<Map<String, dynamic>>filteredSkusByDataApi(String categoryId) {
    return supportDataController
        .getProducts()
        .where((product) =>
    product['category']['id'].toString() == categoryId)
        .toList();
  }


  Map<String, dynamic>? getSkuByDataApi(String skuId) {
    return supportDataController.getProducts().firstWhere(
          (item) => item['id'] == skuId,
          orElse: () => {},
        );
  }

  // List<Map<String, dynamic>?> getSurveyByDataDraft(String surveyId) {
  //   return supportDataController.getSurvey().firstWhere(
  //         (item) => item['id'] == surveyId,
  //     orElse: () => {},
  //   );
  // }

  void onCategorySelected(String? categoryId) {
    selectedCategory.value = categoryId;
    selectedSku.value = null;
    _clearControllers();
  }

  void onSkuSelected(String? skuId) {
    selectedSku.value = skuId;
    if (skuId != null) {
      selectedSkuData.value = getSelectedSkuData;

      final outletChannel = activityController.getSelectedChannel();

      if (selectedSkuData.value != null &&
          selectedSkuData.value!['channel_av3m'] != null &&
          outletChannel != null) {
        final channelAv3m =
            selectedSkuData.value!['channel_av3m'] as Map<String, dynamic>;
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

    final newItem = {
      'id': selectedSku.value,
      'category': categoryData['name'],
      'sku': selectedSkuData.value!['sku'],
      'stock': stockController.value.text,
      'av3m': av3mController.value.text,
      'recommend': recommendController.value.text,
    };

    activityController.addAvailabilityItem(newItem);
    print(activityController.availabilityDraftItems);
    clearForm();
  }

  void _clearControllers() {
    stockController.value.clear();
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
