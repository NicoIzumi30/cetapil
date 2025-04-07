import 'dart:async';
import 'dart:convert';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_order_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:cetapil_mobile/utils/temp_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../database/activity_database.dart';
import '../../model/list_category_response.dart' as Category;
import '../../model/list_activity_response.dart' as Activity;
import '../../widget/custom_alert.dart';

class TambahActivityController extends GetxController {
  late ActivityController activityController = Get.find<ActivityController>();

  late TambahAvailabilityController tambahAvailabilityController =
      Get.find<TambahAvailabilityController>();
  late TambahVisibilityController tambahVisibilityController =
      Get.find<TambahVisibilityController>();
  late TambahOrderController tambahOrderController = Get.find<TambahOrderController>();
  late SupportDataController supportController = Get.find<SupportDataController>();
  final TextEditingController controller = TextEditingController();
  final db = ActivityDatabaseHelper.instance;
  final api = Api();
  final selectedTab = 0.obs;
  final surveyQuestions = <SurveyQuestion>[].obs;
  var outletId = ''.obs;
  var selectedChannel = Rxn<String>();
  Rx<Activity.Data?> detailOutlet = Rx<Activity.Data?>(null);
  RxMap<String, dynamic> detailDraft = <String, dynamic>{}.obs;

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
  /// ITEM TAMBAH ACTIVITY
  final availabilityDraftItems = <Map<String, dynamic>>[].obs;
  final visibilityPrimaryDraftItems = <Map<String, dynamic>>[].obs;
  final visibilitySecondaryDraftItems = <Map<String, dynamic>>[].obs;
  final visibilityKompetitorDraftItems = <Map<String, dynamic>>[].obs;
  final orderDraftItems = <Map<String, dynamic>>[].obs;

  // Survey related fields
  final RxMap<String, TextEditingController> priceControllers =
      RxMap<String, TextEditingController>();
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
  // final visibilityPrimaryImages = Rx<File?>(null);
  // final visibilitySecondaryImages = Rx<File?>(null);
  // final isImageUploading = RxList<bool>([false, false]);

  // Order Section
  List<Map<String, dynamic>> listOrder = [];

  // Add timer-related variables
  final availabilityTime = 0.obs;
  final visibilityTime = 0.obs;
  final knowledgeTime = 0.obs;
  final surveyTime = 0.obs;
  final orderTime = 0.obs;
  Timer? _timer;

  final RxBool _canSubmitState = false.obs;
  bool get canSubmitState => _canSubmitState.value;

  bool disableSecondaryTab(int indexTab) {
    _updateSubmitState();
    bool areAllControllersNotEmpty = priceControllers.values
        .any((controller) => controller.text.isNotEmpty && controller.text != "");
    if (indexTab == 0) {
      return true;
    }
    if (indexTab == 1) {
      if (availabilityDraftItems.isNotEmpty) {
        return true;
      }
    }
    if (indexTab == 2) {
      if (availabilityDraftItems.isNotEmpty) {
        if (visibilityPrimaryDraftItems.length >= 6 &&
            visibilitySecondaryDraftItems.length >= 4 &&
            visibilityKompetitorDraftItems.length >= 2) {
          return true;
        }
      }
    }
    if (indexTab == 3) {
      if (availabilityDraftItems.isNotEmpty) {
        if (visibilityPrimaryDraftItems.length == 6 &&
            visibilitySecondaryDraftItems.length == 4 &&
            visibilityKompetitorDraftItems.length == 2) {
          if (knowledgeTime.value >= 120) {
            /// minimal duration 3 menit
            return true;
          }
        }
      }
    }
    if (indexTab == 4) {
      if (availabilityDraftItems.isNotEmpty) {
        if (visibilityPrimaryDraftItems.length == 6 &&
            visibilitySecondaryDraftItems.length == 4 &&
            visibilityKompetitorDraftItems.length == 2) {
          if (knowledgeTime.value >= 120) {
            /// minimal duration 3 menit
            if (areAllControllersNotEmpty) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  void _updateSubmitState() {
    bool areAllControllersNotEmpty = priceControllers.value.values
        .any((controller) => controller.text.isNotEmpty && controller.text != "");

    _canSubmitState.value = availabilityDraftItems.isNotEmpty &&
        visibilityPrimaryDraftItems.length == 6 &&
        visibilitySecondaryDraftItems.length == 4 &&
        visibilityKompetitorDraftItems.length == 2 &&
        knowledgeTime.value >= 120 &&
        areAllControllersNotEmpty;
  }

  initDetailDraftAvailability() {
    if (detailDraft.isNotEmpty) {
      for (var data in detailDraft["availabilityItems"]) {
        final item = tambahAvailabilityController.getSkuByDataApi(data['product_id']);
        final newItem = {
          'id': data['product_id'],
          'sku': item!['sku'],
          'category': item['category']['name'],
          'availability_exist': data['availability_exist'],
          'stock_on_hand': data['stock_on_hand'],
          'stock_on_inventory': data['stock_on_inventory'],
          'av3m': data['av3m'],
          'recommend': (int.parse(data['stock_on_inventory']) - int.parse(data['av3m'])).toString(),
        };
        addAvailabilityItem(newItem);
        tambahAvailabilityController.clearForm();
      }
    }
  }

  initDetailDraftOrder() {
    if (detailDraft.isNotEmpty) {
      for (var data in detailDraft["orderItems"]) {
        final item = tambahAvailabilityController.getSkuByDataApi(data['product_id']);
        final newItem = {
          'id': data['product_id'],
          'category': item!['category']['name'],
          'sku': item['sku'],
          'jumlah': data['jumlah'],
          'harga': data['harga'],
        };
        addOrderItem(newItem);
        tambahOrderController.clearForm();
      }
    }
  }

  void initDetailDraftVisibility() {
    final visibilityPrimaryDraft = detailDraft["visibilityPrimaryItems"];
    final visibilitySecondaryDraft = detailDraft["visibilitySecondaryItems"];
    final visibilityKompetitorDraft = detailDraft["visibilityKompetitorItems"];

    if (visibilityPrimaryDraft != null) {
      for (var data in visibilityPrimaryDraft) {
        final newItem = {
          'id': 'primary-${data["category"].toString().toLowerCase()}-${data["position"]}',
          'category': data['category'],
          'position': data['position'],
          'posm_type_id': data['posm_type_id'],
          'posm_type_name': data['posm_type_name'],
          'visual_type_id': data['visual_type_id'],
          'visual_type_name': data['visual_type_name'],
          'condition': data['condition'],
          'shelf_width': data['shelf_width'],
          'shelving': data['shelving'],
          'image_visibility': File(data['image_visibility']),
        };
        addPrimaryVisibilityItem(newItem);
        tambahVisibilityController.clearPrimaryForm();
      }
    }

    if (visibilitySecondaryDraft != null) {
      for (var data in visibilitySecondaryDraft) {
        final newItem = {
          'id': 'secondary-${data["category"].toString().toLowerCase()}-${data["position"]}',
          'category': data['category'],
          'position': data['position'],
          'secondary_exist': data['secondary_exist'],
          'display_type': data['display_type'],
          'display_image': File(data['display_image']),
        };
        addSecondaryVisibilityItem(newItem);
        tambahVisibilityController.clearSecondaryForm();
      }
    }

    if (visibilityKompetitorDraft != null) {
      for (var data in visibilityKompetitorDraft) {
        print("Data Kompetitor: $data");
        final newItem = {
          'id': 'kompetitor-${data["category"].toString().toLowerCase()}-${data["position"]}',
          'category': data['category'],
          'position': data['position'],
          'brand_name': data['brand_name'],
          'promo_mechanism': data['promo_mechanism'],
          'promo_periode_start': data['promo_periode_start'],
          'promo_periode_end': data['promo_periode_end'],
          'program_image1': data['program_image1'] != null ? File(data['program_image1']) : null,
          'program_image2': data['program_image2'] != null ? File(data['program_image2']) : null,
        };
        print("New Item: $newItem");
        addKompetitorVisibilityItem(newItem);
        tambahVisibilityController.clearKompetitorForm();
      }
    }
  }

  void initDetailDraftSurvey() {
    if (detailDraft.isEmpty) return;

    final surveyItems = detailDraft['surveyItems'] as List;
    final surveys = supportController.getSurvey();

    for (var item in surveyItems) {
      final id = item['survey_id'].toString();
      // Handle text controllers
      if (item['answer'] != null) {
        if (!priceControllers.containsKey(id)) {
          priceControllers[id] = TextEditingController();
        }
        priceControllers[id]?.text = item['answer'].toString();
      }

      // print("ID : $id - Answer: ${item['answer'] == 'false'}");
      // Handle switch states
      if (!switchStates.containsKey(id)) {
        switchStates[id] = false.obs;
      }
      switchStates[id]?.value = item['answer'].toString() == 'true';
    }

    // Set recommendation group
    final recommendationGroup = surveys.firstWhereOrNull((g) => g['name'] == "Recommndation");
    if (recommendationGroup != null && recommendationGroup['surveys']?.length >= 2) {
      final detailingCountId = recommendationGroup['surveys'][1]['id'].toString();
      final savedCount =
          surveyItems.firstWhereOrNull((item) => item['survey_id'].toString() == detailingCountId);
      if (savedCount != null) {
        priceControllers[detailingCountId]?.text = savedCount['answer'];
      }
    }

    priceControllers.refresh();
    update();
  }

  void _initializeSavedDraft() {
    initDetailDraftAvailability();
    initDetailDraftVisibility();
    initDetailDraftOrder();
    initDetailDraftSurvey();
  }

  @override
  void onInit() {
    super.onInit();
    print("TambahActivityController onInit");
    print("Detail Draft: ${detailDraft}");
    super.onInit();
    initializeData();
  }

  initializeData() {
    initDraftTimers();
    initializeControllers();
    checkAvailabilityForSurvey();
    initDetailDraftSurvey();
    _initializeSavedDraft();
    startTabTimer();
  }

  firstInitializeData() {
    startTabTimer();
    initializeControllers();
  }

  void initializeControllers() {
    final supportController = Get.find<SupportDataController>();
    final questionGroups = supportController.getSurvey();

    for (var group in questionGroups) {
      for (var survey in (group['surveys'] as List<dynamic>? ?? [])) {
        final id = survey['id']?.toString() ?? '';
        if (survey['type'] == 'text' && !priceControllers.containsKey(id)) {
          priceControllers[id] = TextEditingController();
        }
        if (survey['type'] == 'bool' && !switchStates.containsKey(id)) {
          switchStates[id] = true.obs;
        }
      }
    }
  }

  // Also update submitApiActivity to use the same logic
  Future<void> submitApiActivity() async {
    try {
      // Validate all required conditions first
      bool areAllControllersNotEmpty = priceControllers.value.values
          .any((controller) => controller.text.isNotEmpty && controller.text != "");

      // Validate each condition separately to show specific error messages
      if (availabilityDraftItems.isEmpty) {
        throw 'Mohon lengkapi data Availability';
      }

      if (visibilityPrimaryDraftItems.length != 6) {
        throw 'Mohon lengkapi 6 data Visibility Primary. Saat ini terisi ${visibilityPrimaryDraftItems.length} data';
      }

      if (visibilitySecondaryDraftItems.length != 4) {
        throw 'Mohon lengkapi 4 data Visibility Secondary. Saat ini terisi ${visibilitySecondaryDraftItems.length} data';
      }

      if (visibilityKompetitorDraftItems.length != 2) {
        throw 'Mohon lengkapi 2 data Visibility Competitor. Saat ini terisi ${visibilityKompetitorDraftItems.length} data';
      }

      if (knowledgeTime.value < 120) {
        throw 'Waktu minimum untuk Knowledge adalah 2 menit (120 detik). Saat ini: ${knowledgeTime.value} detik';
      }

      if (!areAllControllersNotEmpty) {
        throw 'Mohon lengkapi semua data survey';
      }

      EasyLoading.show(status: 'Submit Data...');

      Map<String, dynamic> data = {
        'sales_activity_id': detailOutlet.value?.id?.toString() ?? '',
        'outlet_id': detailOutlet.value?.outlet?.id?.toString() ?? '',
        'views_knowledge': knowledgeTime.toString(),
        'time_availability': availabilityTime.value.toString(),
        'time_visibility': visibilityTime.value.toString(),
        'time_knowledge': knowledgeTime.value.toString(),
        'time_survey': surveyTime.value.toString(),
        'time_order': orderTime.value.toString(),
        'current_time': DateTime.now().toIso8601String(),
      };

      // Collect all image paths for cleanup later
      List<String?> imagesToCleanup = [];

      // Collect all visibility primary images
      for (var item in visibilityPrimaryDraftItems) {
        if (item['image_visibility'] != null && item['image_visibility'] is File) {
          imagesToCleanup.add(item['image_visibility'].path);
        }
      }

      // Collect all visibility secondary images
      for (var item in visibilitySecondaryDraftItems) {
        if (item['display_image'] != null && item['display_image'] is File) {
          imagesToCleanup.add(item['display_image'].path);
        }
      }

      // Collect all kompetitor images
      for (var item in visibilityKompetitorDraftItems) {
        if (item['program_image1'] != null && item['program_image1'] is File) {
          imagesToCleanup.add(item['program_image1'].path);
        }
        if (item['program_image2'] != null && item['program_image2'] is File) {
          imagesToCleanup.add(item['program_image2'].path);
        }
      }

      // Process surveys and other data...
      final allSurveys = supportController.getSurvey();
      List<Map<String, dynamic>> surveyList = [];

      for (var group in allSurveys) {
        for (var survey in group['surveys']) {
          final id = survey['id']?.toString() ?? '';
          if (id.isEmpty) continue; // Skip if ID is empty

          if (survey['type'] == 'text') {
            final controller = priceControllers[id];
            surveyList.add({
              'survey_question_id': id,
              'answer': (controller?.text?.isEmpty ?? true) ? "0" : controller!.text,
            });
          } else if (survey['type'] == 'bool') {
            final switchState = switchStates[id];
            surveyList.add({
              'survey_question_id': id,
              'answer': (switchState?.value != null ? !switchState!.value : false).toString(),
            });
          }
        }
      }

      /// Filter when data stock on hand and inventory in availability 0
      availabilityDraftItems
          .removeWhere((item) => item['stock_on_hand'] == 0 && item['stock_on_inventory'] == 0);

      orderDraftItems.removeWhere((item) => item['jumlah'] == 0);

      final response = await Api.submitActivity(
        data,
        availabilityDraftItems,
        visibilityPrimaryDraftItems,
        visibilitySecondaryDraftItems,
        visibilityKompetitorDraftItems,
        surveyList,
        orderDraftItems,
      );

      if (response.status != "OK") {
        throw 'Gagal mengirim data: ${response.message ?? 'Unknown error'}';
      }

      final tempImageStorage = TempImageStorage();
      for (String? imagePath in imagesToCleanup) {
        if (imagePath != null) {
          await tempImageStorage.deleteImage(imagePath);
        }
      }

      // Clean up all temporary images in the visibility category
      await tempImageStorage.cleanupTempCategory('visibility');

      _timer?.cancel();

      /// Delete SQLite data if exists
      bool isExists = await db.checkSalesActivityExists(detailOutlet.value!.id!);
      if (isExists) {
        await db.deleteSalesActivity(detailOutlet.value!.id!);
      }
      // Clear all controller data
      clearAllControllerData();
      activityController.initGetActivity();
      EasyLoading.dismiss();
      Get.back();
      CustomAlerts.showSuccess(Get.context!, "Data Berhasil Disimpan",
          "Anda baru menyimpan Data. Silahkan periksa status Outlet pada aplikasi.");
    } catch (e, stackTrace) {
      CustomAlerts.showError(Get.context!, "Gagal Mengirim Data", e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Modified saveDraftActivity method to ensure all fields are saved
  Future<void> saveDraftActivity() async {
    try {
      EasyLoading.show(status: 'Saving draft...');

      bool isEditing = await db.checkSalesActivityExists(detailOutlet.value!.id!);

      // Get all survey questions from support controller to ensure we have all fields
      final allSurveys = supportController.getSurvey();
      List<Map<String, dynamic>> surveyList = [];

      // Process each survey group
      for (var group in allSurveys) {
        for (var survey in group['surveys']) {
          final id = survey['id'].toString();

          if (survey['type'] == 'text') {
            final controller = priceControllers[id];
            surveyList.add({
              'survey_question_id': id,
              'answer': (controller?.text.isEmpty ?? true) ? "0" : controller!.text,
            });
          } else if (survey['type'] == 'bool') {
            final switchState = switchStates[id];
            surveyList.add({
              'survey_question_id': id,
              'answer': (switchState?.value ?? true).toString(),
            });
          }
        }
      }

      final data = {
        'sales_activity_id': detailOutlet.value!.id!,
        'outlet_id': detailOutlet.value!.outlet!.id!,
        'name': detailOutlet.value!.outlet!.name!,
        'category': detailOutlet.value!.outlet!.category!,
        'channel_id': detailOutlet.value!.channel!.id!,
        'channel_name': detailOutlet.value!.outlet!.name!,
        'views_knowledge': knowledgeTime.toString(),
        'time_availability': availabilityTime.toString(),
        'time_visibility': visibilityTime.toString(),
        'time_knowledge': knowledgeTime.toString(),
        'time_survey': surveyTime.toString(),
        'time_order': orderTime.toString(),
        'status': "DRAFTED",
        'checked_in': detailOutlet.value!.checkedIn!,
        'checked_out': DateTime.now().toIso8601String(),
      };

      if (isEditing) {
        await db.updateSalesActivity(
          data: data,
          availabilityItems: availabilityDraftItems,
          visibilityPrimaryItems: visibilityPrimaryDraftItems,
          visibilitySecondaryItems: visibilitySecondaryDraftItems,
          visibilityKompetitorItems: visibilityKompetitorDraftItems,
          surveyItems: surveyList,
          orderItems: orderDraftItems,
        );
      } else {
        await db.insertFullSalesActivity(
          data: data,
          availabilityItems: availabilityDraftItems,
          visibilityPrimaryItems: visibilityPrimaryDraftItems,
          visibilitySecondaryItems: visibilitySecondaryDraftItems,
          visibilityKompetitorItems: visibilityKompetitorDraftItems,
          surveyItems: surveyList,
          orderItems: orderDraftItems,
        );
      }

      _timer?.cancel();
      activityController.initGetActivity(draftRefresh: true);
      EasyLoading.dismiss();
      Get.back();

      CustomAlerts.showSuccess(
          Get.context!,
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

  void initDraftTimers() {
    if (detailDraft.isNotEmpty) {
      // Initialize timers from draft data
      availabilityTime.value = int.tryParse(detailDraft['time_availability'] ?? '0') ?? 0;
      visibilityTime.value = int.tryParse(detailDraft['time_visibility'] ?? '0') ?? 0;
      knowledgeTime.value = int.tryParse(detailDraft['time_knowledge'] ?? '0') ?? 0;
      surveyTime.value = int.tryParse(detailDraft['time_survey'] ?? '0') ?? 0;
      orderTime.value = int.tryParse(detailDraft['time_order'] ?? '0') ?? 0;
    } else {
      // Reset timers to 0 if no draft data
      availabilityTime.value = 0;
      visibilityTime.value = 0;
      knowledgeTime.value = 0;
      surveyTime.value = 0;
      orderTime.value = 0;
    }
  }

  void startTabTimer() {
    _timer?.cancel(); // Cancel any existing timer
    // Initialize timers from draft if available
    initDraftTimers();
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

    // Add this line to auto-update surveys
    checkAvailabilityForSurvey();
  }

  void checkAvailabilityForSurvey({bool knowledge = false}) {
    final surveys = supportController.getSurvey();

    if (!knowledge) {
      final availabilityGroup =
          surveys.firstWhereOrNull((g) => g['title'] == "Apakah POWER SKU tersedia di toko?");
      final priceGroup =
          surveys.firstWhereOrNull((g) => g['title'] == "Berapa harga POWER SKU di toko?");

      if (availabilityGroup != null && availabilityGroup['surveys'] != null) {
        for (var survey in availabilityGroup['surveys']) {
          final id = survey['id'];
          final productId = survey['product_id'];

          bool isAvailable = availabilityDraftItems.any((item) =>
              item['id'] == productId &&
              // item['availability_exist'] == true &&
              (int.parse(item['stock_on_inventory'].toString()) > 0));

          toggleSwitch(id, isAvailable);

          if (isAvailable && priceGroup != null && priceGroup['surveys'] != null) {
            try {
              final priceSurvey =
                  priceGroup['surveys'].firstWhere((s) => s['product_id'] == productId);
              final priceId = priceSurvey['id'];
              final detail = detailDraft['surveyItems']
                  .where((element) => element['survey_id'] == priceId)
                  .toList();
              // Schedule text update for next frame
              Future.microtask(() {
                if (priceControllers.containsKey(priceId)) {
                  // priceControllers[priceId]?.text = detail.isNotEmpty ? detail[0]['answer'] : '0';
                }
              });
            } catch (e) {
              print('No matching price survey found for product $productId');
            }
          }
        }
      }
    }

    if (knowledge) {
      final recommendationGroup = surveys.firstWhereOrNull((g) => g['name'] == "Recommndation");

      if (recommendationGroup != null &&
          recommendationGroup['surveys'] != null &&
          recommendationGroup['surveys'].length >= 2) {
        final detailingSurveyId = recommendationGroup['surveys'][0]['id'];
        final detailingCountId = recommendationGroup['surveys'][1]['id'];

        if (knowledgeTime.value > 0) {
          toggleSwitch(detailingSurveyId, true);

          // Schedule text update for next frame
          Future.microtask(() {
            if (priceControllers.containsKey(detailingCountId)) {
              final currentCount =
                  int.tryParse(priceControllers[detailingCountId]?.text ?? '1') ?? 1;
              priceControllers[detailingCountId]?.text = (currentCount + 1).toString();
            }
          });
        }
      }
    }
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
  void addPrimaryVisibilityItem(Map<String, dynamic> item) {
    final existingIndex =
        visibilityPrimaryDraftItems.indexWhere((existing) => existing['id'] == item['id']);

    if (existingIndex != -1) {
      // Update existing item
      visibilityPrimaryDraftItems[existingIndex] = item;
    } else {
      // Add new item
      visibilityPrimaryDraftItems.add(item);
    }
    visibilityPrimaryDraftItems.refresh();
  }

  void addSecondaryVisibilityItem(Map<String, dynamic> item) {
    final existingIndex =
        visibilitySecondaryDraftItems.indexWhere((existing) => existing['id'] == item['id']);

    print(existingIndex);

    if (existingIndex != -1) {
      // Update existing item
      visibilitySecondaryDraftItems[existingIndex] = item;
    } else {
      // Add new item
      visibilitySecondaryDraftItems.add(item);
    }
    visibilitySecondaryDraftItems.refresh();
  }

  void addKompetitorVisibilityItem(Map<String, dynamic> item) {
    final existingIndex =
        visibilityKompetitorDraftItems.indexWhere((existing) => existing['id'] == item['id']);

    if (existingIndex != -1) {
      // Update existing item
      visibilityKompetitorDraftItems[existingIndex] = item;
    } else {
      // Add new item
      visibilityKompetitorDraftItems.add(item);
    }
    visibilityKompetitorDraftItems.refresh();
  }

  // void updateVisibilityImage(File? file) {
  //   visibilityPrimaryImages.value = file;
  //   update();
  // }
  //
  // void updateVisibilitySecondaryImage(File? file) {
  //   visibilitySecondaryImages.value = file;
  //   update();
  // }

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
    if (!switchStates.containsKey(id)) {
      switchStates[id] = false.obs; // Initialize with true (which shows as "Tidak")
    }
    // Invert the value because "true" shows as "Tidak" in the UI
    switchStates[id]?.value = !value;
  }

  bool getSwitchValue(String id) {
    if (!switchStates.containsKey(id)) {
      switchStates[id] = true.obs;
    }
    return switchStates[id]?.value ?? true;
  }

  // Tab management methods
  void changeTab(int index) {
    selectedTab.value = index;
    if (selectedTab.value != 2 && index != 2) {
      // If leaving Knowledge tab
      Get.delete<CachedVideoController>();
      Get.delete<CachedPdfController>();
    }
    if (selectedTab.value == 2) {
      checkAvailabilityForSurvey(knowledge: true);
    }
    if (selectedTab.value == 3) {
      initializeControllers();
    }
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
    // Cancel any existing timer
    _timer?.cancel();

    // Clear all draft items
    availabilityDraftItems.clear();
    orderDraftItems.clear();
    visibilityPrimaryDraftItems.clear();
    visibilitySecondaryDraftItems.clear();
    visibilityKompetitorDraftItems.clear();

    // Clear product-related data
    selectedProducts.value.clear();
    productInputs.value.clear();
    products.value.clear();

    // Clear all controllers
    for (var controllerMap in productControllers.values) {
      for (var controller in controllerMap.values) {
        controller.clear();
      }
    }
    productControllers.clear(); // Add this line

    // Clear survey controllers
    for (var controller in priceControllers.values) {
      controller.clear();
    }
    priceControllers.clear(); // Add this line

    // Reset switch states
    for (var switchState in switchStates.values) {
      switchState.value = true;
    }
    switchStates.clear(); // Add this line

    // Reset all timers to 0
    availabilityTime.value = 0;
    visibilityTime.value = 0;
    knowledgeTime.value = 0;
    surveyTime.value = 0;
    orderTime.value = 0;

    // Clear detail draft map
    detailDraft.clear();

    // Refresh all observable lists
    availabilityDraftItems.refresh();
    orderDraftItems.refresh();
    visibilityPrimaryDraftItems.refresh();
    visibilitySecondaryDraftItems.refresh();
    visibilityKompetitorDraftItems.refresh();

    update();
  }

  void clearAllControllerData() {
    // Clear all observables
    availabilityDraftItems.clear();
    visibilityPrimaryDraftItems.clear();
    visibilitySecondaryDraftItems.clear();
    visibilityKompetitorDraftItems.clear();
    orderDraftItems.clear();

    // Reset all timers
    availabilityTime.value = 0;
    visibilityTime.value = 0;
    knowledgeTime.value = 0;
    surveyTime.value = 0;
    orderTime.value = 0;

    // Clear all text controllers
    for (var controller in priceControllers.values) {
      controller.clear();
    }
    priceControllers.clear();

    // Reset all switch states
    for (var switchState in switchStates.values) {
      switchState.value = true;
    }
    switchStates.clear();

    // Clear product values
    if (Get.isRegistered<TambahAvailabilityController>()) {
      final availabilityController = Get.find<TambahAvailabilityController>();
      availabilityController.clearForm();
      availabilityController.productValues.clear();
      availabilityController.savedProductValues.clear();
    }

    // Clear visibility controller data
    if (Get.isRegistered<TambahVisibilityController>()) {
      final visibilityController = Get.find<TambahVisibilityController>();
      visibilityController.clearPrimaryForm();
      visibilityController.clearSecondaryForm();
      visibilityController.clearKompetitorForm();
    }

    // Clear order controller data
    if (Get.isRegistered<TambahOrderController>()) {
      final orderController = Get.find<TambahOrderController>();
      orderController.clearForm();
    }

    // Clear draft data
    detailDraft.clear();

    // Refresh all observables
    availabilityDraftItems.refresh();
    visibilityPrimaryDraftItems.refresh();
    visibilitySecondaryDraftItems.refresh();
    visibilityKompetitorDraftItems.refresh();
    orderDraftItems.refresh();

    // Force UI update
    update();
  }

  @override
  void onClose() {
    // for (var controller in priceControllers.values) {
    //   controller.dispose();
    // }
    // priceControllers.clear();

    for (var controllerMap in productControllers.values) {
      for (var controller in controllerMap.values) {
        controller.dispose();
      }
    }

    for (var controller in priceControllers.values) {
      controller.dispose();
    }

    if (Get.isRegistered<TambahAvailabilityController>()) {
      Get.delete<TambahAvailabilityController>();
    }
    if (Get.isRegistered<TambahVisibilityController>()) {
      Get.delete<TambahVisibilityController>();
    }
    if (Get.isRegistered<TambahOrderController>()) {
      Get.delete<TambahOrderController>();
    }
    _timer?.cancel(); // Cancel timer when controller is disposed
    clearAllDraftItems();
    super.onClose();
  }

  @override
  void dispose() {
    if (Get.isRegistered<TambahActivityController>()) {
      Get.delete<TambahActivityController>();
    }
    super.dispose();
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
