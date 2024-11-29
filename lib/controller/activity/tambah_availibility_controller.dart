import 'package:get/get.dart';
import '../../model/list_product_sku_response.dart';
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahAvailabilityController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  
  // Selected values using String IDs
  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  final groupSelectedSku = <Map<String, dynamic>>[].obs;
  
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
    // selectedSku.value = null; // Reset SKU when category changes
    groupSelectedSku.clear();
  }

  void onSkuSelected(Map<String, dynamic>? skuId) {
    // selectedSku.value = skuId!['id'];
    groupSelectedSku.add(skuId!);
  }
  
  void removeItem(sku){
    groupSelectedSku.removeWhere((item)=> item['sku'] == sku );
  }
}