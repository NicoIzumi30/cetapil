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
      children: [
        CachedVideoPlayerWidget(),
        CachedPDFViewerWidget(),
      ],
    );
  }
}

class CachedVideoPlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CachedVideoController>(
      init: CachedVideoController(),
      builder: (controller) {
        if (!controller.isInitialized.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading video...'),
              ],
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
                  Obx(() => GestureDetector(
                        onTap: controller.playPause,
                        child: Container(
                          color: Colors.black26,
                          child: Icon(
                            controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            // Video controls
            Container(
              padding: const EdgeInsets.all(8),
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
                  // Time display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                              _formatDuration(controller.position.value),
                              style: const TextStyle(color: Colors.grey),
                            )),
                        Obx(() => Text(
                              _formatDuration(controller.duration.value),
                              style: const TextStyle(color: Colors.grey),
                            )),
                      ],
                    ),
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
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}

class CachedPDFViewerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CachedPdfController>(
      init: CachedPdfController(),
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.localPath.value.isEmpty) {
            return const Center(
              child: Text('No PDF available'),
            );
          }

          return GestureDetector(
            onTap: () => _showFullScreenPDF(context, controller.localPath.value),
            child: Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: PDFView(
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
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => Text(
                          'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
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
