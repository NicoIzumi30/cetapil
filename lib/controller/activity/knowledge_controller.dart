import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:get/get.dart';

import '../support_data_controller.dart';

class KnowledgeController extends GetxController {
  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();
  final videoPath = Rxn<String>();
  final urlVideo = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    initVideoPath();
    initPdfPath();
  }

  initVideoPath() {
    final channel = activityController.detailOutlet.value!.channel!.name;
    final filteredData = supportDataController.knowledge
        .where((item) => item['knowledge_channel']['name'] == channel)
        .toList();

    if (filteredData.isNotEmpty) {
      videoPath.value = filteredData.first['path_video'];
    } else {
      videoPath.value = null;
    }
  }

  initPdfPath(){
    urlVideo.value = supportDataController.getKnowledge().first['path_pdf'];
  }
}
