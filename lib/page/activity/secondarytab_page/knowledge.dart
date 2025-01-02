import 'dart:async';

import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:chewie/chewie.dart';
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

class CachedVideoPlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!KnowledgeController.cachedVideoController.isInitialized.value) {
        return const _LoadingWidget();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: () => KnowledgeController.cachedVideoController.toggleControls(),
              child: KnowledgeController.cachedVideoController.chewieController != null
                  ? Chewie(controller: KnowledgeController.cachedVideoController.chewieController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
    });
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
