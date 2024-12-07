import 'dart:async';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/activity/tambah_order_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../database/activity_database.dart';
import '../../model/list_category_response.dart' as Category;
import '../../model/list_activity_response.dart' as Activity;
import '../../widget/custom_alert.dart';

class TambahActivityController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final db = ActivityDatabaseHelper.instance;
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

  // Order Section
  List<Map<String, dynamic>> listOrder = [];

  // Add timer-related variables
  final availabilityTime = 0.obs;
  final visibilityTime = 0.obs;
  final knowledgeTime = 0.obs;
  final surveyTime = 0.obs;
  final orderTime = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // initGetSurveyQuestion();
    // initListCategory();

    // Start the timer when controller is initialized
    startTabTimer();
  }

  Future<void> submitApiActivity(String activityId, outletId) async {
    try {
      // final String? currentOutletId = Get.arguments?['id'];
      // final bool isEditing = currentOutletId != null;
      EasyLoading.show(status: 'Submit Data...');

      Map<String, dynamic> data = {
        'sales_activity_id': activityId,
        'outlet_id': outletId,
        'views_knowledge': "111",
        'time_availability': availabilityTime.value.toString(),
        'time_visibility': visibilityTime.value.toString(),
        'time_knowledge': knowledgeTime.value.toString(),
        'time_survey': surveyTime.value.toString(),
        'time_order': orderTime.value.toString(),
        'current_time': DateTime.now().toIso8601String(),
      };

      List<Map<String, dynamic>> surveyList = [
        ...priceControllers.entries.map((entry) => {
              'survey_question_id': entry.key.toString() ?? "",
              'answer': entry.value.text ?? "",
            }),
        ...switchStates.entries.map((entry) => {
              'survey_question_id': entry.key.toString() ?? "",
              'answer': entry.value.value.toString() ?? "",
            }),
      ];

      final response = await Api.submitActivity(
        data,
        availabilityDraftItems,
        visibilityDraftItems,
        surveyList,
        orderDraftItems,
      );

      if (response.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }

      _timer?.cancel();
      EasyLoading.dismiss();
      Get.back();
      // REFRESH LIST ACTIVITY
      CustomAlerts.showSuccess(
          Get.context!, // Use Get.context instead of the previous context
          "Data Berhasil Disimpan",
          "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");
      // await refreshOutlets();
    } catch (e) {
      print('Error submit dati: $e');
      Get.snackbar(
        'Error',
        'Failed to submit data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveDraftActivity(String activityId, outletId, checkedIn,
      channelId, channelName, outletName, outletCategory) async {
    try {
      EasyLoading.show(status: 'Saving draft...');

      bool isEditing = await db.checkSalesActivityExists(activityId);

      List<Map<String, dynamic>> surveyList = [
        ...priceControllers.entries.map((entry) => {
              'survey_question_id': entry.key,
              'answer': entry.value.text,
            }),
        ...switchStates.entries.map((entry) => {
              'survey_question_id': entry.key,
              'answer': entry.value.value.toString(),
            }),
      ];

      final data = {
        'sales_activity_id': activityId,
        'outlet_id': outletId,
        'name': outletName,
        'category': outletCategory,
        'channel_id': channelId,
        'channel_name': channelName,
        'views_knowledge': "111",
        'time_availability': availabilityTime.toString(),
        'time_visibility': visibilityTime.toString(),
        'time_knowledge': knowledgeTime.toString(),
        'time_survey': surveyTime.toString(),
        'time_order': orderTime.toString(),
        'status': "DRAFTED",
        'checked_in': checkedIn.toString(),
        'checked_out': DateTime.now().toIso8601String(),
      };

      if (isEditing) {
        await db.updateSalesActivity(
            data: data,
            availabilityItems: availabilityDraftItems,
            visibilityItems: visibilityDraftItems,
            surveyItems: surveyList,
            orderItems: orderDraftItems);
      } else {
        await db.insertFullSalesActivity(
            data: data,
            availabilityItems: availabilityDraftItems,
            visibilityItems: visibilityDraftItems,
            surveyItems: surveyList,
            orderItems: orderDraftItems);
      }

      // await loadOutlets();
      // clearForm();

      // Navigate back first
      EasyLoading.dismiss();
      Get.back();

      // Then show the success alert
      CustomAlerts.showSuccess(
          Get.context!, // Use Get.context instead of the previous context
          isEditing ? "Draft Berhasil Diperbarui" : "Draft Berhasil Disimpan",
          isEditing
              ? "Anda baru memperbarui Draft. Silahkan periksa status Draft pada aplikasi."
              : "Anda baru menyimpan Draft. Silahkan periksa status Draft pada aplikasi.");
    } catch (e) {
      print('Error saving draft: $e');
      Get.snackbar(
        'Error',
        'Failed to save draft: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void startTabTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Increment the timer based on current selected tab
      switch (selectedTab.value) {
        case 0:
          availabilityTime.value++;
          break;
        case 1:
          visibilityTime.value++;
          break;
        case 2:
          knowledgeTime.value++;
          break;
        case 3:
          surveyTime.value++;
          break;
        case 4:
          orderTime.value++;
          break;
      }

      print("Availability: ${getFormattedTime(availabilityTime.value)}");
      print("Visibility: ${getFormattedTime(visibilityTime.value)}");
      print("Knowledge: ${getFormattedTime(knowledgeTime.value)}");
      print("Survey: ${getFormattedTime(surveyTime.value)}");
      print("Order: ${getFormattedTime(orderTime.value)}");
    });
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

  // In TambahActivityController
  void addVisibilityItem(Map<String, dynamic> item) {
    final existingIndex = visibilityDraftItems
        .indexWhere((existing) => existing['id'] == item['id']);

    print(existingIndex);

    if (existingIndex != -1) {
      // Update existing item
      visibilityDraftItems[existingIndex] = item;
    } else {
      // Add new item
      visibilityDraftItems.add(item);
    }
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
  // initListCategory() async {
  //   try {
  //     setLoadingState(true);
  //     setErrorState(false);
  //     final response = await Api.getCategoryList();
  //     if (response.status == "OK") {
  //       itemsCategory.value = response.data!;
  //     } else {
  //       setErrorState(true, response.message ?? 'Failed to load data');
  //     }
  //   } catch (e) {
  //     setErrorState(true, 'Connection error. Please check your internet connection and try again.');
  //     print('Error initializing categories: $e');
  //   } finally {
  //     setLoadingState(false);
  //   }
  // }

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
  // Future<void> initGetSurveyQuestion() async {
  //   try {
  //     setLoadingState(true);
  //     setErrorState(false);

  //     final response = await Api.getSurveyQuestion();

  //     if (response.status == "OK" && response.data != null) {
  //       final sortedData = [...response.data!]..sort((a, b) {
  //           if (a.name == 'Recommendation') return 1;
  //           if (b.name == 'Recommendation') return -1;
  //           return 0;
  //         });

  //       surveyQuestions.assignAll(sortedData);

  //       priceControllers.clear();
  //       switchStates.clear();

  //       for (var question in sortedData) {
  //         for (var survey in question.surveys ?? []) {
  //           final id = survey.id ?? '';
  //           if (survey.type == 'text') {
  //             priceControllers[id] = TextEditingController();
  //           } else if (survey.type == 'bool') {
  //             switchStates[id] = false.obs;
  //           }
  //         }
  //       }
  //     } else {
  //       setErrorState(true, response.message ?? 'Failed to load data');
  //     }
  //   } catch (e) {
  //     setErrorState(true, 'Connection error. Please check your internet connection and try again.');
  //     print('Error initializing survey questions: $e');
  //   } finally {
  //     setLoadingState(false);
  //   }
  // }

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

  setDetailOutlet(Activity.Data data) {
    detailOutlet.value = data;
    print(detailOutlet.value!.id);
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

  // Add this method to TambahActivityController
  void clearAllDraftItems() {
    // Clear all draft items
    availabilityDraftItems.clear();
    orderDraftItems.clear();
    visibilityDraftItems.clear();

    // Clear visibility related fields
    visibilityImages.value = [null, null];
    isImageUploading.value = [false, false];

    // Clear product related fields
    selectedProducts.value.clear();
    productInputs.value.clear();
    products.value.clear();

    // Clear controllers
    for (var controllerMap in productControllers.values) {
      for (var controller in controllerMap.values) {
        controller.clear();
      }
    }

    // Clear survey fields
    for (var controller in priceControllers.values) {
      controller.clear();
    }
    for (var switchState in switchStates.values) {
      switchState.value = false;
    }

    // Refresh all observable lists
    availabilityDraftItems.refresh();
    orderDraftItems.refresh();
    visibilityDraftItems.refresh();
    update();
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
    _timer?.cancel(); // Cancel timer when controller is disposed
    super.onClose();
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
