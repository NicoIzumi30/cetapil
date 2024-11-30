import 'dart:io';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/list_category_response.dart' as Category;
import '../../model/list_posm_response.dart' as POSM;
import '../../model/list_posm_response.dart' as Visual;
import '../../model/list_activity_response.dart' as Activity;
import '../../model/dropdown_model.dart' as Model;
import '../../model/visibility.dart' as Visibility;
import '../../model/visibility.dart';

class TambahActivityController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final api = Api();
  final selectedTab = 0.obs;
  final surveyQuestions = <SurveyQuestion>[].obs;
  var outletId = ''.obs;
  Rx<Activity.Data?> detailOutlet = Rx<Activity.Data?>(null);

  // Loading states for each tab
  final isLoadingAvailability = true.obs;
  final isLoadingVisibility = true.obs;
  final isLoadingKnowledge = true.obs;
  final isLoadingSurvey = true.obs;
  final isLoadingOrder = true.obs;

  // Error states for each tab
  final hasErrorAvailability = false.obs;
  final hasErrorVisibility = false.obs;
  final hasErrorKnowledge = false.obs;
  final hasErrorSurvey = false.obs;
  final hasErrorOrder = false.obs;

  // Error messages for each tab
  final errorMessageAvailability = ''.obs;
  final errorMessageVisibility = ''.obs;
  final errorMessageKnowledge = ''.obs;
  final errorMessageSurvey = ''.obs;
  final errorMessageOrder = ''.obs;

  final Map<String, TextEditingController> priceControllers = {};
  final Map<String, RxBool> switchStates = {};

  ///Availability
  var itemsCategory = <Category.Data>[].obs;
  final selectedItems = <Category.Data>[].obs;

  // Products
  final products = RxMap<String, List<String>>().obs;
  final selectedProducts = RxList<String>().obs;
  final productInputs = RxMap<String, Map<String, String>>().obs;
  // Initialize controllers
  final Map<String, Map<String, TextEditingController>> productControllers = {};


  void removeItem(String item) {
    selectedItems.removeWhere((items) => items.name == item);
  }

  // Method to set the outlet_id
  void setOutletId(String id) {
    outletId.value = id;
  }

  void handleProductSelect(String product) {
    selectedProducts.value.add(product);
    update();
  }

  void handleProductDeselect(String product) {
    selectedProducts.value.remove(product);
    update();
  }

  void updateProductInput(String productId, String field, String value) {
    if (!productInputs.value.containsKey(productId)) {
      productInputs.value[productId] = {};
    }
    productInputs.value[productId]![field] = value;
  }

  void initProductController(String productId) {
    if (!productControllers.containsKey(productId)) {
      productControllers[productId] = {
        'stock': TextEditingController(),
        'av3m': TextEditingController(),
        'recommend': TextEditingController()
      };
    }
  }

  /// Visibility
  var itemsPOSM = <Model.Data>[].obs;
  final selectedPOSM = ''.obs;
  final selectedIdPOSM = ''.obs;
  var itemsVisual = <Model.Data>[].obs;
  final selectedVisual = ''.obs;
  final selectedIdVisual = ''.obs;
  final selectedCondition = ''.obs;
  final RxList<File?> visibilityImages = RxList([null, null]); // [frontView, banner, landmark]
  final RxList<String> imageUrls = RxList(['', '']);
  final RxList<String> imagePath = RxList(['', '']);
  final RxList<String> imageFilename = RxList(['', '']);
  final RxList<bool> isImageUploading = RxList([false, false]);
  var listVisibility = <Visibility.Visibility>[].obs;

  @override
  void onInit() {
    super.onInit();
    // initListCategory();
    initGetSurveyQuestion();
    initListPosm();
    initListVisual();
  }

  // Helper methods to get states for current tab
  bool get isCurrentTabLoading {
    switch (selectedTab.value) {
      case 0:
        return isLoadingAvailability.value;
      case 1:
        return isLoadingVisibility.value;
      case 2:
        return isLoadingKnowledge.value;
      case 3:
        return isLoadingSurvey.value;
      case 4:
        return isLoadingOrder.value;
      default:
        return false;
    }
  }

  bool get hasCurrentTabError {
    switch (selectedTab.value) {
      case 0:
        return hasErrorAvailability.value;
      case 1:
        return hasErrorVisibility.value;
      case 2:
        return hasErrorKnowledge.value;
      case 3:
        return hasErrorSurvey.value;
      case 4:
        return hasErrorOrder.value;
      default:
        return false;
    }
  }

  String get currentTabErrorMessage {
    switch (selectedTab.value) {
      case 0:
        return errorMessageAvailability.value;
      case 1:
        return errorMessageVisibility.value;
      case 2:
        return errorMessageKnowledge.value;
      case 3:
        return errorMessageSurvey.value;
      case 4:
        return errorMessageOrder.value;
      default:
        return '';
    }
  }

  void setLoadingState(bool isLoading) {
    switch (selectedTab.value) {
      case 0:
        isLoadingAvailability.value = isLoading;
        break;
      case 1:
        isLoadingVisibility.value = isLoading;
        break;
      case 2:
        isLoadingKnowledge.value = isLoading;
        break;
      case 3:
        isLoadingSurvey.value = isLoading;
        break;
      case 4:
        isLoadingOrder.value = isLoading;
        break;
    }
  }

  void setErrorState(bool hasError, [String? message]) {
    switch (selectedTab.value) {
      case 0:
        hasErrorAvailability.value = hasError;
        errorMessageAvailability.value = message ?? '';
        break;
      case 1:
        hasErrorVisibility.value = hasError;
        errorMessageVisibility.value = message ?? '';
        break;
      case 2:
        hasErrorKnowledge.value = hasError;
        errorMessageKnowledge.value = message ?? '';
        break;
      case 3:
        hasErrorSurvey.value = hasError;
        errorMessageSurvey.value = message ?? '';
        break;
      case 4:
        hasErrorOrder.value = hasError;
        errorMessageOrder.value = message ?? '';
        break;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  /// Availability Section
  initListCategory() async {
    try {
      setLoadingState(true);
      setErrorState(false);
      final response = await Api.getCategoryList();
      if (response.status == "OK") {
        itemsCategory.value = response.data!;
      } else {
        setErrorState(true, response.message ?? 'Failed to load data');
      }
    } catch (e) {
      setErrorState(true, 'Connection error. Please check your internet connection and try again.');
      print('Error initializing survey questions: $e');
    } finally {
      setLoadingState(false);
    }
  }

  getProductbyCategory() async {
    try {
      setLoadingState(true);
      setErrorState(false);

      final data = {
        "outlet_id": outletId.value,
        "ids": selectedItems.map((item) => item.id.toString()).toList()
      };

      final response = await Api.getProductList(data);
      if (response.status == "OK" && response.data != null) {
        // Convert data to Map<String, List<String>>
        final groupedProducts = <String, List<String>>{};

// Handle null check for response.data
        if (response.data != null) {
          for (var item in response.data!) {
            final categoryName = item.category?.name;
            final productName = item.sku;

            if (categoryName != null && productName != null) {
              if (!groupedProducts.containsKey(categoryName)) {
                groupedProducts[categoryName] = [];
              }
              groupedProducts[categoryName]!.add(productName);
            }
          }
        }

        products.value = groupedProducts.obs;
      }
    } catch (e) {
      setErrorState(true, 'Connection error');
      print('Error: $e');
    } finally {
      setLoadingState(false);
    }
  }

  /// Visibility Section
  initListPosm() async {
    try {
      setLoadingState(true);
      setErrorState(false);
      final response = await Api.getItemPOSMList();
      print("succes get item posm ");
      if (response.status == "OK") {
        itemsPOSM.value = response.data!;
      }else {
        setErrorState(true, 'Failed to load data');
      }
    } catch (e) {
      setErrorState(true,
          'Connection error. Please check your internet connection and try again.');
      print('Error initializing survey questions: $e');
    } finally {
      setLoadingState(false);
    }
  }

  initListVisual() async {
    try {
      setLoadingState(true);
      setErrorState(false);
      final response = await Api.getItemVisualList();
      print("succes get item visual ");
      if (response.status == "OK") {
        itemsVisual.value = response.data!;
      }else {
        setErrorState(true, 'Failed to load data');
      }
    } catch (e) {
      setErrorState(true,
          'Connection error. Please check your internet connection and try again.');
      print('Error initializing survey questions: $e');
    } finally {
      setLoadingState(false);
    }
  }

  void updateImage(int index, File? file) {
    visibilityImages[index] = file;
    update();
  }

  insertVisibility(){
    Visibility.Visibility data = Visibility.Visibility(
      typeVisibility: TypeVisibility(id: selectedIdPOSM.value, type: selectedPOSM.value),
      typeVisual: TypeVisual(id: selectedIdVisual.value, type: selectedVisual.value),
      condition: selectedCondition.value,
      image1: visibilityImages[0],
      image2: visibilityImages[1],
    );
    listVisibility.add(data);
    /// Clear variable
    selectedPOSM.value = "";
    selectedIdPOSM.value = "";
    selectedVisual.value = "";
    selectedIdVisual.value = "";
    selectedCondition.value = "";
    imagePath.value = ['', ''];
    isImageUploading.value = [false, false];
    visibilityImages.value = [null, null];

    Get.back();
  }

  /// Survey Section
  var switchValue = true.obs;

  Future<void> initGetSurveyQuestion() async {
    try {
      setLoadingState(true);
      setErrorState(false);

      final response = await Api.getSurveyQuestion();

      if (response.status == "OK" && response.data != null) {
        final sortedData = [...response.data!]..sort((a, b) {
            if (a.name == 'Recommendation') return 1;
            if (b.name == 'Recommendation') return -1;
            return 0;
          });

        surveyQuestions.assignAll(sortedData);

        priceControllers.clear();
        switchStates.clear();

        for (var question in sortedData) {
          for (var survey in question.surveys ?? []) {
            final id = survey.id ?? '';
            if (survey.type == 'text') {
              priceControllers[id] = TextEditingController();
            } else if (survey.type == 'bool') {
              switchStates[id] = false.obs;
            }
          }
        }
      } else {
        setErrorState(true, response.message ?? 'Failed to load data');
      }
    } catch (e) {
      setErrorState(true,
          'Connection error. Please check your internet connection and try again.');
      print('Error initializing survey questions: $e');
    } finally {
      setLoadingState(false);
    }
  }

  void toggleSwitch(String id, bool value) {
    print('Toggling switch $id to $value'); // Debug print
    final switchValue = switchStates[id];
    if (switchValue != null) {
      switchValue.value = value;
      print('Switch $id is now ${switchValue.value}'); // Debug print
    }
  }

  bool getSwitchValue(String id) {
    return switchStates[id]?.value ?? true; // Default to true for 'Ada'
  }

  /// Order Section

  @override
  void onClose() {
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
