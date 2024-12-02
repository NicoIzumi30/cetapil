import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:cetapil_mobile/database/support_database.dart';
import 'package:get/get.dart';
import '../../api/api.dart';
import 'package:cetapil_mobile/model/list_product_sku_response.dart' as SKU;
import '../model/list_category_response.dart' as Category;
import '../model/list_channel_response.dart' as Channel;
import '../model/list_knowledge_response.dart' as Knowledge;
import '../model/survey_question_response.dart';

class SupportDataController extends GetxController {
  final supportDB = SupportDatabaseHelper.instance;
  final storage = GetStorage();
  Timer? _timer;
  var isLoading = false.obs;

  // Observable variables for storing SQLite data
  final survey = <Map<String, dynamic>>[].obs;
  var products = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var channels = <Channel.Data>[].obs;
  var knowledge = <Map<String, dynamic>>[].obs;
  var posmTypes = <Map<String, dynamic>>[].obs;
  var visualTypes = <Map<String, dynamic>>[].obs;

  static const String LAST_FETCH_DATE_KEY = 'last_fetch_date';

  @override
  void onInit() {
    super.onInit();
    checkData();
    startTimeCheck();
    // initProductListData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> checkData() async {
    await loadLocalData();

    // Only force refresh if data is empty
    if (products.isEmpty ||
        categories.isEmpty ||
        channels.isEmpty ||
        knowledge.isEmpty ||
        survey.isEmpty) {
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

      // Load categories
      categories.value = await supportDB.getAllCategories();

      // Load channels
      channels.value = await supportDB.getAllChannel();

      // Load Knowledge
      knowledge.value = await supportDB.getAllKnowledge();

      // Load Survey Question
      survey.value = await supportDB.getAllSurveyQuestions();

      // Load POSM types
      posmTypes.value = await supportDB.getAllPosmTypes();
      
      // Load Visual types
      visualTypes.value = await supportDB.getAllVisualTypes();
    } catch (e) {
      print("Error loading local data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void checkAndFetchData() {
    final lastFetchDate = storage.read<String>(LAST_FETCH_DATE_KEY);
    final today = DateTime.now().toString().split(' ')[0];

    if (lastFetchDate != today) {
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
        initQuestionSurvey(),
        initPosmTypeData(),
        initVisualTypeData(),
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
        print("Product error ${responseProduct.message}");
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
        print("Knowledge error = ${responseKnowledge.message}");
      }
    } catch (e) {
      print("Knowledge error = $e");
    }
  }

  Future<void> initQuestionSurvey() async {
    try {
      final responseSurvey = await Api.getSurveyQuestion();

      if (responseSurvey.status == "OK" && responseSurvey.data != null) {
        final sortedData = [...responseSurvey.data!]..sort((a, b) {
            if (a.name == 'Recommendation') return 1;
            if (b.name == 'Recommendation') return -1;
            return 0;
          });
        for (final data in sortedData) {
          await supportDB.insertSurveyQuestion(data);
        }
        // supportDB.insertSurveyQuestion(sortedData);
        // surveyQuestions.assignAll(sortedData);
      } else {
        print("Survey error = ${responseSurvey.message}");
      }
    } catch (e) {
      print("Survey error = $e");
    }
  }

  Future<void> initPosmTypeData() async {
    try {
      final responsePosmType = await Api.getItemPOSMList();
      if (responsePosmType.status == "OK") {
        for (final posmType in responsePosmType.data ?? []) {
          await supportDB.insertPosmType(posmType);
        }
      } else {
        print("POSM Type error = ${responsePosmType.message}");
      }
    } catch (e) {
      print("POSM Type error = $e");
    }
  }

  Future<void> initVisualTypeData() async {
    try {
      final responseVisualType = await Api.getItemVisualList();
      if (responseVisualType.status == "OK") {
        for (final visualType in responseVisualType.data ?? []) {
          await supportDB.insertVisualType(visualType);
        }
      } else {
        print("Visual Type error = ${responseVisualType.message}");
      }
    } catch (e) {
      print("Visual Type error = $e");
    }
  }

  // Helper methods to access data
  List<Map<String, dynamic>> getProducts() => products;
  List<Map<String, dynamic>> getCategories() => categories;
  List<Channel.Data> getChannels() => channels;
  List<Map<String, dynamic>> getKnowledge() => knowledge;
  List<Map<String, dynamic>> getSurvey() => survey;
  List<Map<String, dynamic>> getPosmTypes() => posmTypes;
  List<Map<String, dynamic>> getVisualTypes() => visualTypes;
}
