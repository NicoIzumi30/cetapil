import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/support_data_controller.dart';

// tambah_order_controller.dart (continued)
class TambahOrderController extends GetxController {
  late SupportDataController supportDataController = Get.find<SupportDataController>();
  late TambahActivityController tambahActivityController = Get.find<TambahActivityController>();

  // Selected values
  final selectedCategory = Rxn<String>();
  final productValues = <String, Map<String, String>>{}.obs;
  final savedProductValues = <String, Map<String, Map<String, String>>>{}.obs;

  final selectedSku = Rxn<String>();
  final selectedSkuData = Rxn<Map<String, dynamic>>();

  // Form controllers
  var jumlahController = TextEditingController().obs;
  var hargaController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedValues();
  }

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
    for (var item in tambahActivityController.orderDraftItems) {
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
          'jumlah': item['jumlah'].toString(),
          'harga': item['harga'].toString(),
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
          final matchingDraftItems = tambahActivityController.orderDraftItems
              .where((item) => item['category'] == categoryName);

          if (matchingDraftItems.isNotEmpty) {
            // Populate values from matching draft items
            for (var item in matchingDraftItems) {
              final skuId = item['id'].toString();
              productValues[skuId] = {
                'jumlah': item['jumlah'].toString(),
                'harga': item['harga'].toString(),
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
                  'jumlah': '0',
                  'harga': '0',
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
            'jumlah': '0',
            'harga': '0',
          };

      // Parse harga value - remove currency formatting
      String hargaValue = values['harga'] ?? '0';
      hargaValue = hargaValue.replaceAll(RegExp(r'[^\d]'), ''); // Remove non-digits

      updatedItems.add({
        'id': skuId,
        'product_id': sku['id'],
        'category': sku['category']['name'],
        'sku': sku['sku'],
        'jumlah': int.tryParse(values['jumlah'] ?? '0') ?? 0,
        'harga': int.tryParse(hargaValue) ?? 0, // Use cleaned harga value
      });
    }

    // Keep existing items from other categories
    final remainingItems = tambahActivityController.orderDraftItems.where((item) {
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

    tambahActivityController.orderDraftItems.clear();
    tambahActivityController.orderDraftItems.addAll([...remainingItems, ...updatedItems]);
    tambahActivityController.orderDraftItems.refresh();

    // Clear the form
    clearForm();
  }

  void clearForm() {
    productValues.clear();
    productValues.value = {};
    selectedCategory.value = null;
  }

  void updateProductValues(String skuId, Map<String, String> values) {
    productValues[skuId] = values;
  }

  /// function isnot used
  Map<String, dynamic>? get getSelectedSkuData {
    if (selectedSku.value == null) return null;
    return filteredSkus.firstWhere(
      (product) => product['id'].toString() == selectedSku.value,
      orElse: () => {},
    );
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

    final newItem = {
      'id': selectedSku.value,
      'category': categoryData['name'],
      'sku': selectedSkuData.value!['sku'],
      'jumlah': jumlahController.value.text,
      'harga': hargaController.value.text,
    };

    tambahActivityController.addOrderItem(newItem);
    clearForm();
  }

  void _clearControllers() {
    jumlahController.value.clear();
    hargaController.value.clear();
  }

  @override
  void onClose() {
    jumlahController.value.dispose();
    hargaController.value.dispose();
    super.onClose();
  }
}
