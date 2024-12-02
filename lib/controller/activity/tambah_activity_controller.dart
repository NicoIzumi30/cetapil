import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../model/list_category_response.dart' as Category;
import '../../model/list_activity_response.dart' as Activity;

class TambahActivityController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final api = Api();
  final selectedTab = 0.obs;
  final surveyQuestions = <SurveyQuestion>[].obs;
  var outletId = ''.obs;
  var selectedChannel = Rxn<String>();
  Rx<Activity.Data?> detailOutlet = Rx<Activity.Data?>(null);

  // Loading and error states
  final isLoadingAvailability = true.obs;
  final isLoadingVisibility = true.obs;
  final isLoadingKnowledge = true.obs;
  final isLoadingSurvey = true.obs;
  final isLoadingOrder = true.obs;

  final hasErrorAvailability = false.obs;
  final hasErrorVisibility = false.obs;
  final hasErrorKnowledge = false.obs;
  final hasErrorSurvey = false.obs;
  final hasErrorOrder = false.obs;

  final errorMessageAvailability = ''.obs;
  final errorMessageVisibility = ''.obs;
  final errorMessageKnowledge = ''.obs;
  final errorMessageSurvey = ''.obs;
  final errorMessageOrder = ''.obs;

  // Consolidated draft items for all sections
  final availabilityDraftItems = <Map<String, dynamic>>[].obs;
  final orderDraftItems = <Map<String, dynamic>>[].obs;
  final visibilityDraftItems = <Map<String, dynamic>>[].obs;

  // Survey related fields
  final Map<String, TextEditingController> priceControllers = {};
  final Map<String, RxBool> switchStates = {};
  var switchValue = true.obs;

  ///Availability
  var itemsCategory = <Category.Data>[].obs;
  final selectedItems = <Category.Data>[].obs;

  // Products
  final products = RxMap<String, List<String>>().obs;
  final selectedProducts = RxList<String>().obs;
  final productInputs = RxMap<String, Map<String, String>>().obs;
  final Map<String, Map<String, TextEditingController>> productControllers = {};

  // Visibility specific fields
  final visibilityImages = RxList<File?>([null, null]);
  final isImageUploading = RxList<bool>([false, false]);

  @override
  void onInit() {
    super.onInit();
    initGetSurveyQuestion();
    initListCategory();
  }

  // Draft items management methods
  void addAvailabilityItem(Map<String, dynamic> item) {
    final existingIndex = availabilityDraftItems.indexWhere(
      (existing) => existing['id'] == item['id'],
    );

    if (existingIndex != -1) {
      availabilityDraftItems[existingIndex] = item;
    } else {
      availabilityDraftItems.add(item);
    }
    availabilityDraftItems.refresh();
  }

  void addOrderItem(Map<String, dynamic> item) {
    final existingIndex = orderDraftItems.indexWhere(
      (existing) => existing['id'] == item['id'],
    );

    if (existingIndex != -1) {
      orderDraftItems[existingIndex] = item;
    } else {
      orderDraftItems.add(item);
    }
    orderDraftItems.refresh();
  }

  void addVisibilityItem(Map<String, dynamic> item) {
    visibilityDraftItems.add(item);
    visibilityDraftItems.refresh();
  }

  void removeAvailabilityItem(String id) {
    availabilityDraftItems.removeWhere((item) => item['id'] == id);
    availabilityDraftItems.refresh();
  }

  void removeOrderItem(String id) {
    orderDraftItems.removeWhere((item) => item['id'] == id);
    orderDraftItems.refresh();
  }

  void removeVisibilityItem(int index) {
    visibilityDraftItems.removeAt(index);
    visibilityDraftItems.refresh();
  }

  // Availability methods
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
      print('Error initializing categories: $e');
    } finally {
      setLoadingState(false);
    }
  }

  // Visibility image methods
  void updateVisibilityImage(int index, File? file) {
    visibilityImages[index] = file;
    update();
  }

  // Product selection methods
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

  // Survey methods
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
      setErrorState(true, 'Connection error. Please check your internet connection and try again.');
      print('Error initializing survey questions: $e');
    } finally {
      setLoadingState(false);
    }
  }

  void toggleSwitch(String id, bool value) {
    final switchValue = switchStates[id];
    if (switchValue != null) {
      switchValue.value = value;
    }
  }

  bool getSwitchValue(String id) {
    return switchStates[id]?.value ?? true;
  }

  // Tab management methods
  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  // Outlet methods
  void setOutletId(String id) {
    outletId.value = id;
  }

  String? getSelectedChannel() {
    if (detailOutlet.value != null && detailOutlet.value!.channel != null) {
      return detailOutlet.value!.channel!.name;
    }
    return null;
  }

  void setDetailOutlet(Activity.Data data) {
    detailOutlet.value = data;
  }

  // Loading and error management methods
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

  @override
  void onClose() {
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    for (var controllerMap in productControllers.values) {
      for (var controller in controllerMap.values) {
        controller.dispose();
      }
    }
    super.onClose();
  }
}
