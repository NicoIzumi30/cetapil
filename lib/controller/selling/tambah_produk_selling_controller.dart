import 'package:get/get.dart';
import '../../model/list_product_sku_response.dart' as SKU;
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahProdukSellingController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  
  // Selected values using String IDs
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  
  // Get list of SKUs for selected category
  List<Map<String, dynamic>> get filteredSkus {
    if (selectedCategory.value == null) return [];
    return supportDataController.getProducts()
        .where((product) => 
            product['category']['id'].toString() == selectedCategory.value)
        .toList();
  }

  void onCategorySelected(String? categoryId) {
    selectedCategory.value = categoryId;
    selectedSku.value = null; // Reset SKU when category changes
  }

  void onSkuSelected(String? skuId) {
    selectedSku.value = skuId;
  }
}