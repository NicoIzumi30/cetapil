// tambah_availability_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/support_data_controller.dart';
import '../../controller/activity/tambah_activity_controller.dart';
import '../selling/selling_controller.dart';

class TambahAvailabilityController extends GetxController {
  late SupportDataController supportDataController = Get.find<SupportDataController>();
  late TambahActivityController tambahActivityController = Get.find<TambahActivityController>();

  // Selected values
  final selectedCategory = Rxn<String>();
  final productValues = <String, Map<String, String>>{}.obs;
  final savedProductValues = <String, Map<String, Map<String, String>>>{}.obs;

  final selectedSku = Rxn<String>();
  final selectedSkuData = Rxn<Map<String, dynamic>>();

  // Form controllers
  var stockController = TextEditingController().obs;
  var av3mController = TextEditingController().obs;
  var recommendController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedValues();
  }

  ///GET SKU by id Category
  List<Map<String, dynamic>> get filteredSkus {
    if (selectedCategory.value == null) return [];
    return supportDataController
        .getProducts()
        .where((product) => product['category']['id'].toString() == selectedCategory.value)
        .toList();
  }

  String get filteredCategory {
    if (selectedCategory.value == null) return "";
    return supportDataController.getCategories().firstWhere(
          (cat) => cat['id'].toString() == selectedCategory.value,
      orElse: () => {'name': null},
    )['name'];
  }

  void _loadSavedValues() {
    savedProductValues.clear();

    // Group existing draft items by category
    for (var item in tambahActivityController.availabilityDraftItems) {
      final product = supportDataController.getProducts().firstWhere(
            (product) => product['id'].toString() == item['id'].toString(),
        orElse: () => {
          'category': {'id': null}
        },
      );

      final categoryId = product['category']?['id']?.toString();
      if (categoryId != null) {
        if (!savedProductValues.containsKey(categoryId)) {
          savedProductValues[categoryId] = {};
        }

        savedProductValues[categoryId]![item['id'].toString()] = {
          'stock': item['stock'].toString(),
          'av3m': item['av3m'].toString(),
          'recommend': item['recommend'].toString(),
          // 'price': item['price'].toString(),
        };
      }
    }
  }

  void onCategorySelected(String? categoryId) {
    if (selectedCategory.value != categoryId) {
      // Clear current form values
      productValues.clear();
      selectedCategory.value = categoryId;

      if (categoryId != null) {
        // First check if there are matching draft items in the sellingGetController
        final categoryName = supportDataController.getCategories().firstWhere(
              (cat) => cat['id'].toString() == categoryId,
          orElse: () => {'name': null},
        )['name'];

        if (categoryName != null) {
          // Find draft items matching this category
          final matchingDraftItems =
          tambahActivityController.availabilityDraftItems.where((item) => item['category'] == categoryName);

          if (matchingDraftItems.isNotEmpty) {
            // Populate values from matching draft items
            for (var item in matchingDraftItems) {
              final skuId = item['id'].toString();
              productValues[skuId] = {
                'stock': item['stock'].toString(),
                'av3m': item['av3m'].toString(),
                'recommend': item['recommend'].toString(),
                // 'price': item['price'].toString(),
              };
            }
          } else {
            // If no matching draft items, check saved values or initialize with zeros
            if (savedProductValues.containsKey(categoryId)) {
              productValues.addAll(Map.from(savedProductValues[categoryId]!));
            } else {
              // Initialize new products with zeros
              final products = supportDataController
                  .getProducts()
                  .where((product) => product['category']['id'].toString() == categoryId);

              for (var product in products) {
                final skuId = product['id'].toString();
                productValues[skuId] = {
                  'stock': '0',
                  'av3m': '0',
                  'recommend': '0',
                  // 'price': '0',
                };
              }
            }
          }
        }
      }
    }
  }

  void saveAllProducts() {
    if (selectedCategory.value == null) return;

    // Save current values to savedProductValues
    savedProductValues[selectedCategory.value!] = Map.from(productValues);

    // Update draft items
    final updatedItems = <Map<String, dynamic>>[];
    final products = supportDataController
        .getProducts()
        .where((product) => product['category']['id'].toString() == selectedCategory.value);

    for (var sku in products) {
      final skuId = sku['id'].toString();
      final values = productValues[skuId] ??
          {
            'stock': '0',
            'av3m': '0',
            'recommend': '0',
            // 'price': '0',
          };

      updatedItems.add({
        'id': skuId,
        'product_id': sku['id'],
        'category': sku['category']['name'],
        'sku': sku['sku'],
        'stock': int.tryParse(values['stock'] ?? '0') ?? 0,
        'av3m': int.tryParse(values['av3m'] ?? '0') ?? 0,
        'recommend': int.tryParse(values['recommend'] ?? '0') ?? 0,
        // 'price': int.tryParse(values['price'] ?? '0') ?? 0,
      });
    }

    // Keep existing items from other categories
    final remainingItems = tambahActivityController.availabilityDraftItems.where((item) {
      final itemCategory = supportDataController
          .getProducts()
          .firstWhere(
            (product) => product['id'].toString() == item['id'].toString(),
        orElse: () => {
          'category': {'id': null}
        },
      )['category']['id']
          ?.toString();
      return itemCategory != selectedCategory.value;
    }).toList();

    tambahActivityController.availabilityDraftItems.clear();
    tambahActivityController.availabilityDraftItems.addAll([...remainingItems, ...updatedItems]);
    tambahActivityController.availabilityDraftItems.refresh();

    // Clear the form
    clearForm();
  }

  void clearForm() {
    productValues.clear();
    selectedCategory.value = null;
  }

  void updateProductValues(String skuId, Map<String, String> values) {
    productValues[skuId] = values;
  }

  /// function isnot used
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

  void onSkuSelected(String? skuId) {
    selectedSku.value = skuId;
    if (skuId != null) {
      selectedSkuData.value = getSelectedSkuData;

      final outletChannel = tambahActivityController.getSelectedChannel();

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

    tambahActivityController.addAvailabilityItem(newItem);
    clearForm();
  }

  void _clearControllers() {
    stockController.value.clear();
    recommendController.value.clear();
  }



  @override
  void onClose() {
    stockController.value.dispose();
    av3mController.value.dispose();
    recommendController.value.dispose();
    super.onClose();
  }
}
