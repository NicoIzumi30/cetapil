import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../support_data_controller.dart';

// Updated KnowledgeController
class KnowledgeController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();
  final videoPath = Rxn<String>();
  final pdfPath = Rxn<String>();

  // Change to lazy-put to ensure proper lifecycle management
  static CachedVideoController get cachedVideoController {
    if (!Get.isRegistered<CachedVideoController>()) {
      Get.put(CachedVideoController(), permanent: false);
    }
    return Get.find<CachedVideoController>();
  }

  static CachedPdfController get cachedPdfController {
    if (!Get.isRegistered<CachedPdfController>()) {
      Get.put(CachedPdfController(), permanent: false);
    }
    return Get.find<CachedPdfController>();
  }

  @override
  void onInit() {
    super.onInit();
    initPaths();
    ever(activityController.selectedTab, (tab) {
      if (tab != 2) {
        // 2 is Knowledge tab index
        cachedVideoController.pauseVideo();
      }
    });
  }

  void initPaths() {
    try {
      pdfPath.value = supportDataController.knowledge.first['path_pdf'];
      videoPath.value = supportDataController.knowledge.first['path_video'];
    } catch (e) {
      print('Error initializing paths: $e');
    }
  }



  @override
  void onClose() {
    if (Get.isRegistered<CachedVideoController>()) {
      final controller = Get.find<CachedVideoController>();
      controller.pauseVideo();
    }
    super.onClose();
  }
}
