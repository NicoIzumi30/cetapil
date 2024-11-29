import '../../database/support_database.dart';
import '../../model/list_product_sku_response.dart';
import '../../model/list_category_response.dart' as Category;

import 'package:get/get.dart';

class TambahAvailabilityController extends GetxController {
  final supportDB = SupportDatabaseHelper.instance;
  RxList<Data> produkSkuLocal = <Data>[].obs;
  RxList<Category.Data> categoryLokal = <Category.Data>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategoryLocal();
    getSKULocal();
  }

  getCategoryLocal() async {
    print("ggg");
    isLoading.value = true;
    final List<Map<String, dynamic>> category = await supportDB.getAllCategories();

    categoryLokal.value = category.map((category) => Category.Data.fromJson(category)).toList();
    isLoading.value = false;
  }

  getSKULocal() async {
    print("asdasd");
    isLoading.value = true;
    final List<Map<String, dynamic>> products =  await supportDB.getAllProducts();

    produkSkuLocal.value = products.map((product) => Data.fromJson(product)).toList();
    print("${produkSkuLocal[0].category}");
    isLoading.value = false;
  }
}
