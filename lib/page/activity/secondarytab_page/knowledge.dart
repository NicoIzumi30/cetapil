import 'dart:async';

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
        // Video Section
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
            child: Obx(() {
              if (controller.videoPath.value == null || controller.videoPath.value!.isEmpty) {
                return Container(
                  height: 240,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No video available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return CachedVideoPlayerWidget();
            }),
          ),
        ),

        // PDF Section
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
            child: Obx(() {
              if (controller.pdfPath.value == null || controller.pdfPath.value!.isEmpty) {
                return Container(
                  height: 240,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No PDF available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return CachedPDFViewerWidget();
            }),
          ),
        ),
      ],
    );
  }
}

class CachedVideoPlayerWidget extends StatefulWidget {
  @override
  _CachedVideoPlayerWidgetState createState() => _CachedVideoPlayerWidgetState();
}

class _CachedVideoPlayerWidgetState extends State<CachedVideoPlayerWidget> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final videoController = KnowledgeController.cachedVideoController;

    return Obx(() {
      if (!videoController.isInitialized.value) {
        return const _LoadingWidget();
      }

      return Column(
        children: <Widget>[
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: videoController.videoController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(videoController.videoController),
                  _ControlsOverlay(controller: videoController.videoController),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(videoController.position.value),
                                style: const TextStyle(color: Colors.white)),
                            Text(_formatDuration(videoController.duration.value),
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      VideoProgressIndicator(
                        videoController.videoController,
                        allowScrubbing: true,
                        padding: const EdgeInsets.only(top: 5.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
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
