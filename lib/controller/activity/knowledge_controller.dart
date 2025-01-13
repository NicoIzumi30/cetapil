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
  late CachedVideoController _cachedVideoController;

  static CachedVideoController get cachedVideoController {
    if (!Get.isRegistered<CachedVideoController>()) {
      Get.put(CachedVideoController());
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
    _cachedVideoController = Get.put(CachedVideoController());
    
    initPaths();
    ever(activityController.selectedTab, (tab) {
      if (tab != 2) {
        // Use the correct method - pause() instead of pauseVideo()
        if(_cachedVideoController.videoController == null) {
          return;
        }
        if (_cachedVideoController.videoController!.value.isPlaying) {
          _cachedVideoController.videoController?.pause();
        }
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
      if (_cachedVideoController.videoController!.value.isPlaying) {
        _cachedVideoController.videoController?.pause();
      }
    }
    super.onClose();
  }
}
