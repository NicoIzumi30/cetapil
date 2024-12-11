import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:get/get.dart';

import '../support_data_controller.dart';

// Updated KnowledgeController
class KnowledgeController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();
  final videoPath = Rxn<String>();
  final pdfPath = Rxn<String>();
  
  // Create static instances of controllers to persist them
  static final cachedVideoController = Get.put(CachedVideoController(), permanent: true);
  static final cachedPdfController = Get.put(CachedPdfController(), permanent: true);

  @override
  void onInit() {
    super.onInit();
    initPaths();
  }

  void initPaths() {
    try {
      final channel = activityController.detailOutlet.value?.channel?.name;
      if (channel != null) {
        final filteredData = supportDataController.knowledge
            .where((item) => item['knowledge_channel']['name'] == channel)
            .toList();

        if (filteredData.isNotEmpty) {
          videoPath.value = filteredData.first['path_video'];
          pdfPath.value = filteredData.first['path_pdf'];
        }
      }
    } catch (e) {
      print('Error initializing paths: $e');
    }
  }

  @override
  void onClose() {
    // Don't delete controllers here since we want to persist them
    super.onClose();
  }
}
