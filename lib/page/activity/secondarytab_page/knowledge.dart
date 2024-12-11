import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';

class KnowledgePage extends GetView<KnowledgeController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Training Video Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Video',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedVideoPlayerWidget(),
          ),
        ),

        // Training Material Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'PDF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedPDFViewerWidget(),
          ),
        ),
      ],
    );
  }
}

class CachedVideoPlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CachedVideoController>(
      init: KnowledgeController.cachedVideoController,
      builder: (controller) {
        if (!controller.isInitialized.value) {
          return Container(
            height: 240,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading video...'),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Video display
            AspectRatio(
              aspectRatio: controller.videoController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(controller.videoController),
                  // Play/Pause button overlay
                  Obx(() => AnimatedOpacity(
                        opacity: controller.isPlaying.value ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: controller.playPause,
                          child: Container(
                            color: Colors.black26,
                            child: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            // Enhanced video controls
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black87,
              child: Column(
                children: [
                  // Progress bar
                  Obx(() => SliderTheme(
                        data: SliderThemeData(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          trackHeight: 4,
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey[700],
                          thumbColor: Colors.blue,
                        ),
                        child: Slider(
                          value: controller.position.value.inMilliseconds.toDouble(),
                          min: 0,
                          max: controller.duration.value.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            controller.seekTo(Duration(
                              milliseconds: value.toInt(),
                            ));
                          },
                        ),
                      )),
                  // Control buttons and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Obx(() => Icon(
                                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                )),
                            onPressed: controller.playPause,
                          ),
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: Colors.white),
                            onPressed: () => controller.seekTo(
                                Duration(seconds: controller.position.value.inSeconds - 10)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10, color: Colors.white),
                            onPressed: () => controller.seekTo(
                                Duration(seconds: controller.position.value.inSeconds + 10)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Text(
                                  _formatDuration(controller.position.value),
                                  style: const TextStyle(color: Colors.white),
                                )),
                            const Text(' / ', style: TextStyle(color: Colors.white)),
                            Obx(() => Text(
                                  _formatDuration(controller.duration.value),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class CachedPDFViewerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CachedPdfController>(
      init: KnowledgeController.cachedPdfController,
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            return Container(
              height: 400,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.localPath.value.isEmpty) {
            return Container(
              height: 400,
              child: const Center(
                child: Text('No training material available'),
              ),
            );
          }

          return GestureDetector(
            onTap: () => _showFullScreenPDF(context, controller.localPath.value),
            child: Column(
              children: [
                Container(
                  height: 400,
                  child: Stack(
                    children: [
                      PDFView(
                        filePath: controller.localPath.value,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: true,
                        pageFling: true,
                        pageSnap: true,
                        onRender: (pages) {
                          controller.totalPages.value = pages ?? 0;
                        },
                        onPageChanged: (page, _) {
                          controller.currentPage.value = page ?? 0;
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        },
                      ),
                      // Overlay controls
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black87,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                    'Page ${controller.currentPage.value + 1} of ${controller.totalPages.value}',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                                    onPressed: () =>
                                        _showFullScreenPDF(context, controller.localPath.value),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showFullScreenPDF(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPDFViewer(filePath: filePath),
      ),
    );
  }
}

class FullScreenPDFViewer extends StatefulWidget {
  final String filePath;

  const FullScreenPDFViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  _FullScreenPDFViewerState createState() => _FullScreenPDFViewerState();
}

class _FullScreenPDFViewerState extends State<FullScreenPDFViewer> {
  int currentPage = 0;
  int totalPages = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Page ${currentPage + 1} of $totalPages',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              // Implement zoom functionality if needed
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            onRender: (pages) {
              setState(() {
                totalPages = pages ?? 0;
                isLoading = false;
              });
            },
            onPageChanged: (page, _) {
              setState(() {
                currentPage = page ?? 0;
              });
            },
            onError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
