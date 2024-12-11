import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class KnowledgeController extends GetxController {
  static const String baseUrl = 'https://dev-cetaphil.i-am.host/storage';

  final supportDataController = Get.find<SupportDataController>();
  final activityController = Get.find<TambahActivityController>();

  final videoPath = Rxn<String>();
  final pdfPath = Rxn<String>();
  final urlVideo = Rxn<String>();

  final isLoadingVideo = true.obs;
  final isLoadingPdf = true.obs;

  Rxn<VideoPlayerController> videoPlayerController = Rxn<VideoPlayerController>();
  final isVideoInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    initVideoPath();
    initPdfPath();
  }

  Future<void> initVideoPath() async {
    try {
      isLoadingVideo.value = true;

      final channel = activityController.detailOutlet.value!.channel!.name;
      final filteredData = supportDataController.knowledge
          .where((item) => item['knowledge_channel']['name'] == channel)
          .toList();

      if (filteredData.isNotEmpty) {
        final path = filteredData.first['path_video'];
        if (path != null && path.isNotEmpty) {
          // Prepend base URL if path doesn't include it
          final fullPath = path.startsWith('http') ? path : '$baseUrl$path';
          videoPath.value = fullPath;
          print('Full video path: $fullPath');
          await initializeVideoPlayer(fullPath);
        }
      }
    } catch (e) {
      print('Error initializing video path: $e');
      videoPath.value = null;
    } finally {
      isLoadingVideo.value = false;
    }
  }

  Future<void> initPdfPath() async {
    try {
      isLoadingPdf.value = true;
      final pdfUrl = supportDataController.getKnowledge().first['path_pdf'];
      if (pdfUrl != null && pdfUrl.isNotEmpty) {
        // Prepend base URL if path doesn't include it
        final fullPath = pdfUrl.startsWith('http') ? pdfUrl : '$baseUrl$pdfUrl';
        pdfPath.value = fullPath;
        urlVideo.value = fullPath;
        print('Full PDF path: $fullPath');
      }
    } catch (e) {
      print('Error initializing PDF path: $e');
      pdfPath.value = null;
    } finally {
      isLoadingPdf.value = false;
    }
  }

  Future<void> initializeVideoPlayer(String path) async {
    try {
      if (videoPlayerController.value != null) {
        await videoPlayerController.value!.dispose();
      }

      print('Initializing video player with path: $path');
      final controller = VideoPlayerController.networkUrl(Uri.parse(path));
      await controller.initialize();
      videoPlayerController.value = controller;
      isVideoInitialized.value = true;
    } catch (e) {
      print('Error initializing video player: $e');
      isVideoInitialized.value = false;
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}
