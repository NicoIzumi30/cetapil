import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';
import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';

class KnowledgePage extends StatelessWidget {
  KnowledgePage({Key? key}) : super(key: key);

  final KnowledgeController controller = Get.find<KnowledgeController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Training Video",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            CustomVideoPlayer(),
            
            SizedBox(height: 24),
            
            Text(
              "Training Material",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            CustomPDFViewer(),
          ],
        ),
      ),
    );
  }
}

class CustomVideoPlayer extends StatelessWidget {
  const CustomVideoPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<KnowledgeController>(
      builder: (controller) {
        if (controller.isLoadingVideo.value) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.videoPath.value == null || 
            !controller.isVideoInitialized.value ||
            controller.videoPlayerController.value == null) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No video available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller.videoPlayerController.value!),
                GestureDetector(
                  onTap: () {
                    if (controller.videoPlayerController.value!.value.isPlaying) {
                      controller.videoPlayerController.value!.pause();
                    } else {
                      controller.videoPlayerController.value!.play();
                    }
                    controller.update();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        controller.videoPlayerController.value!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomPDFViewer extends StatelessWidget {
  const CustomPDFViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<KnowledgeController>(
      builder: (controller) {
        if (controller.isLoadingPdf.value) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.pdfPath.value == null) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No PDF available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => Get.to(() => FullPDFViewer(filePath: controller.pdfPath.value!)),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: controller.pdfPath.value != null ? PDFView(
                    filePath: controller.pdfPath.value!,
                    enableSwipe: false,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: false,
                    pageSnap: false,
                    defaultPage: 0,
                    fitPolicy: FitPolicy.HEIGHT,
                    onError: (error) {
                      print('PDF Error: $error');
                    },
                  ) : const SizedBox(),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fullscreen, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'View Full',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FullPDFViewer extends StatelessWidget {
  final String filePath;

  const FullPDFViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Material'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        fitPolicy: FitPolicy.WIDTH,
        onError: (error) {
          print('PDF Error: $error');
          Get.snackbar('Error', 'Failed to load PDF');
        },
      ),
    );
  }
}