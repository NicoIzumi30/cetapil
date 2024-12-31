import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/list_product_sku_response.dart' as SKU;
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahProdukSellingController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final sellingGetController = Get.find<SellingController>();

  final selectedCategory = Rxn<String>();
  final productValues = <String, Map<String, String>>{}.obs;
  final savedProductValues = <String, Map<String, Map<String, String>>>{}.obs;

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

  void _loadSavedValues() {
    savedProductValues.clear();

    // Group existing draft items by category
    for (var item in sellingGetController.draftItems) {
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
          'qty': item['qty'].toString(),
          'price': item['price'].toString(),
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
              sellingGetController.draftItems.where((item) => item['category'] == categoryName);

          if (matchingDraftItems.isNotEmpty) {
            // Populate values from matching draft items
            for (var item in matchingDraftItems) {
              final skuId = item['id'].toString();
              productValues[skuId] = {
                'qty': item['qty'].toString(),
                'price': item['price'].toString(),
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
                  'qty': '0',
                  'price': '0',
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
            'qty': '0',
            'price': '0',
          };

      updatedItems.add({
        'id': skuId,
        'product_id': sku['id'],
        'category': sku['category']['name'],
        'sku': sku['sku'],
        'qty': int.tryParse(values['qty'] ?? '0') ?? 0,
        'price': sku['harga'] ?? 0,
      });
    }

    // Keep existing items from other categories
    final remainingItems = sellingGetController.draftItems.where((item) {
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

    sellingGetController.draftItems.clear();
    sellingGetController.draftItems.addAll([...remainingItems, ...updatedItems]);
    sellingGetController.draftItems.refresh();

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
}
