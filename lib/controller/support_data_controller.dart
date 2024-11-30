import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:cetapil_mobile/database/support_database.dart';
import 'package:get/get.dart';
import '../../api/api.dart';
import 'package:cetapil_mobile/model/list_product_sku_response.dart' as SKU;
import '../model/list_category_response.dart' as Category;
import '../model/list_channel_response.dart' as Channel;
import '../model/list_knowledge_response.dart' as Knowledge;

class SupportDataController extends GetxController {
  final supportDB = SupportDatabaseHelper.instance;
  final storage = GetStorage();
  Timer? _timer;
  var isLoading = false.obs;

  // Observable variables for storing SQLite data
  var products = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var channels = <Channel.Data>[].obs;
  var knowledge = <Map<String, dynamic>>[].obs;

  static const String LAST_FETCH_DATE_KEY = 'last_fetch_date';

  @override
  void onInit() {
    super.onInit();
    checkData();
    startTimeCheck();
    initProductListData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> checkData() async {
    await loadLocalData();

    // Only force refresh if data is empty
    if (products.isEmpty || categories.isEmpty || channels.isEmpty || knowledge.isEmpty) {
      await initAllData();
    } else {
      // If data exists, check for daily refresh
      checkAndFetchData();
    }
  }

  Future<void> loadLocalData() async {
    try {
      isLoading.value = true;

      // Load products with their categories
      products.value = await supportDB.getAllProducts();
      print("products.value ${products.value}");

      // Load categories
      categories.value = await supportDB.getAllCategories();

      // Load channels
      channels.value = await supportDB.getAllChannel();

      // Load Knowledge
      knowledge.value = await supportDB.getAllKnowledge();
    } catch (e) {
      print("Error loading local data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void checkAndFetchData() {
    final lastFetchDate = storage.read<String>(LAST_FETCH_DATE_KEY);
    final today = DateTime.now().toString().split(' ')[0];

    if (lastFetchDate == today) {
      initAllData();
      storage.write(LAST_FETCH_DATE_KEY, today);
    }
  }

  void startTimeCheck() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      checkAndFetchData();
    });
  }

  Future<void> initAllData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        initProductListData(),
        initCategoryListData(),
        initChannelListData(),
        initKnowledgeData(),
      ]);
      // Reload local data after updating SQLite
      await loadLocalData();
    } catch (e) {
      print("Error initializing data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initProductListData() async {
    try {
      final responseProduct = await Api.getAllProductSKU();
      if (responseProduct.status == "OK") {
        for (final product in responseProduct.data ?? []) {
          await supportDB.insertProduct(product);
        }
      } else {
        print("Product error = ${responseProduct.message}");
      }
    } catch (e) {
      print("Product error = $e");
    }
  }

  Future<void> initCategoryListData() async {
    try {
      final responseCategory = await Api.getCategoryList();
      if (responseCategory.status == "OK") {
        for (final category in responseCategory.data ?? []) {
          await supportDB.insertCategory(category);
        }
      } else {
        print("Category error = ${responseCategory.message}");
      }
    } catch (e) {
      print("Category error = $e");
    }
  }

  Future<void> initChannelListData() async {
    try {
      final responseChannel = await Api.getAllChannel();
      if (responseChannel.status == "OK") {
        for (final channel in responseChannel.data ?? []) {
          await supportDB.insertChannel(channel);
        }
      } else {
        print("Channel error = ${responseChannel.message}");
      }
    } catch (e) {
      print("Channel error = $e");
    }
  }

  Future<void> initKnowledgeData() async {
    try {
      final responseKnowledge = await Api.getknowledge();
      if (responseKnowledge.status == "OK") {
        for (final knowledge in responseKnowledge.data ?? []) {
          await supportDB.insertKnowledge(knowledge);
        }
      } else {
        print("Channel error = ${responseKnowledge.message}");
      }
    } catch (e) {
      print("Channel error = $e");
    }
  }

  // Helper methods to access data
  List<Map<String, dynamic>> getProducts() => products;
  List<Map<String, dynamic>> getCategories() => categories;
  List<Channel.Data> getChannels() => channels;
  List<Map<String, dynamic>> getKnowledge() => knowledge;
}
