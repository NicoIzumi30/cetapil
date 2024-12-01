import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/list_category_response.dart' as Category;
import '../../model/list_activity_response.dart' as Activity;

class TambahActivityController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final api = Api();
  final selectedTab = 0.obs;
  final surveyQuestions = <SurveyQuestion>[].obs;
  var outletId = ''.obs;
  var selectedChannel = Rxn<String>(); // Added for channel selection
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

  void removeItem(Map<String, dynamic> item) {
    final availabilityController = Get.find<TambahAvailabilityController>();
    availabilityController.draftItems
        .removeWhere((draft) => draft['id'] == item['id'] && draft['sku'] == item['sku']);
    availabilityController.draftItems.refresh(); // Force UI update
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

  @override
  void onInit() {
    super.onInit();
    initGetSurveyQuestion();
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

  String? getSelectedChannel() {
    if (detailOutlet.value != null && detailOutlet.value!.channel != null) {
      return detailOutlet.value!.channel!.name;
    }
    return null;
  }

  // Set the detail outlet data
  void setDetailOutlet(Activity.Data data) {
    detailOutlet.value = data;
    print(getSelectedChannel());
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
      setErrorState(true, 'Connection error. Please check your internet connection and try again.');
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

  @override
  void onClose() {
    for (var controller in priceControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
