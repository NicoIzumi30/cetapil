import 'package:get/get.dart';
import '../../model/list_product_sku_response.dart';
import '../../model/list_category_response.dart' as Category;
import '../../controller/support_data_controller.dart';

class TambahAvailabilityController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();

  final selectedCategory = Rxn<String>();
  final selectedSku = Rxn<String>();
  final groupSelectedIdSku = <String>[].obs;
  final groupedSkuInfo = <Map<String, dynamic>>[].obs;

  // Get list of SKUs for selected category
  List<Map<String, dynamic>> get filteredSkus {
    if (selectedCategory.value == null) return [];
    return supportDataController
        .getProducts()
        .where((product) =>
            product['category']['id'].toString() == selectedCategory.value)
        .toList();
  }

  String get getSelectedCategoryName {
    return supportDataController
        .getCategories()
        .where(
            (category) => category['id'].toString() == selectedCategory.value)
        .first['name'];
  }

  // List<Map<String,dynamic>> get getGroupedSkuName {
  //   return supportDataController
  //       .getProducts().where((product) => product['id'].toString() == groupSelectedIdSku.).toList();
  // }


  String getSkuName(String id) {
    final data = supportDataController
        .products()
        .where(
            (products) => products['id'].toString() == id).first;
    return data["sku"];
  }

  void onCategorySelected(String? categoryId) {
    selectedCategory.value = categoryId;
    selectedSku.value = null; // Reset SKU when category changes
    groupSelectedIdSku.clear();
  }

  void onSkuSelected(String? skuId) {
    selectedSku.value = skuId;
    groupSelectedIdSku.add(skuId!);
  }
}
