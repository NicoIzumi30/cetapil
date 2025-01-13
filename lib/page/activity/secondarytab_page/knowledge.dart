import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/cache_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class KnowledgePage extends GetView<KnowledgeController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Video'),
        _buildVideoCard(),
        _buildSectionHeader('PDF'),
        _buildPdfCard(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildVideoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Obx(() {
          if (controller.videoPath.value == null || controller.videoPath.value!.isEmpty) {
            return _buildNoMediaAvailableWidget('No video available', Icons.videocam_off);
          }
          return GetBuilder<CachedVideoController>(
            init: KnowledgeController.cachedVideoController,
            builder: (videoController) {
              if (videoController.hasError.value) {
                return _buildErrorWidget(videoController.errorMessage.value);
              }

              if (!videoController.isInitialized.value || videoController.videoController == null) {
                return const _LoadingWidget();
              }

              return CachedVideoPlayerWidget(controller: videoController);
            },
          );
        }),
      ),
    );
  }

  Widget _buildPdfCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Obx(() {
          if (controller.pdfPath.value == null || controller.pdfPath.value!.isEmpty) {
            return _buildNoMediaAvailableWidget('No PDF available', Icons.picture_as_pdf);
          }
          return GetBuilder<CachedPdfController>(
            init: KnowledgeController.cachedPdfController,
            builder: (pdfController) => CachedPDFViewerWidget(),
          );
        }),
      ),
    );
  }

  Widget _buildNoMediaAvailableWidget(String message, IconData icon) {
    return Container(
      height: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      height: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CachedVideoPlayerWidget extends StatelessWidget {
  final CachedVideoController controller;

  const CachedVideoPlayerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: controller.toggleControls,
                child: VideoPlayer(controller.videoController!),
              ),
              if (controller.isLoading.value) const CircularProgressIndicator(),
              Obx(() => Visibility(
                    visible: controller.showControls.value,
                    child: _buildControls(context),
                  )),
              Obx(() => AnimatedOpacity(
                    opacity: controller.showControls.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: controller.playPause,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildProgressBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildTimeText(),
                const SizedBox(width: 8),
                Obx(() => Text(
                      ' / ${_formatDuration(controller.duration.value)}',
                      style: const TextStyle(color: Colors.white70),
                    )),
                const Spacer(),
                _buildVolumeButton(),
                _buildFullscreenButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final duration = controller.duration.value.inMilliseconds.toDouble();
      final position = controller.position.value.inMilliseconds.toDouble();

      return SliderTheme(
        data: SliderThemeData(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
        child: Slider(
          value: position.clamp(0, duration),
          min: 0,
          max: duration,
          onChanged: (value) {
            controller.seekTo(Duration(milliseconds: value.toInt()));
          },
          activeColor: Colors.red,
          inactiveColor: Colors.white24,
        ),
      );
    });
  }

  Widget _buildTimeText() {
    return Obx(() => Text(
          _formatDuration(controller.position.value),
          style: const TextStyle(color: Colors.white),
        ));
  }

  Widget _buildVolumeButton() {
    return Obx(() => IconButton(
          icon: Icon(
            controller.videoController?.value.volume != 0 ? Icons.volume_up : Icons.volume_off,
            color: Colors.white,
          ),
          onPressed: () {
            if (controller.videoController == null) return;
            final newVolume = controller.videoController!.value.volume > 0 ? 0.0 : 1.0;
            controller.videoController!.setVolume(newVolume);
          },
        ));
  }

  Widget _buildFullscreenButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.fullscreen, color: Colors.white),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenVideoPage(controller: controller),
          ),
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

class FullScreenVideoPage extends StatefulWidget {
  final CachedVideoController controller;

  const FullScreenVideoPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
  }

  @override
  void dispose() {
    _setPortraitOrientation();
    super.dispose();
  }

  Future<void> _setLandscapeOrientation() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _setPortraitOrientation() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _setPortraitOrientation();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // Video Player
              Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.videoController!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video Player
                      GestureDetector(
                        onTap: () => widget.controller.toggleControls(),
                        child: VideoPlayer(widget.controller.videoController!),
                      ),

                      // Loading Indicator
                      if (widget.controller.isLoading.value) const CircularProgressIndicator(),

                      // Video Controls Overlay
                      Obx(() => Visibility(
                            visible: widget.controller.showControls.value,
                            child: _buildControls(context),
                          )),

                      // Center Play/Pause Button
                      Obx(() => AnimatedOpacity(
                            opacity: widget.controller.showControls.value ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () => widget.controller.playPause(),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.controller.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: 16,
                left: 16,
                child: Obx(() => AnimatedOpacity(
                      opacity: widget.controller.showControls.value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () async {
                            await _setPortraitOrientation();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Progress Bar
          _buildProgressBar(),

          // Bottom Controls Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Current Time
                _buildTimeText(),
                const SizedBox(width: 8),

                // Duration
                Obx(() => Text(
                      ' / ${_formatDuration(widget.controller.duration.value)}',
                      style: const TextStyle(color: Colors.white70),
                    )),

                const Spacer(),

                // Volume Control
                IconButton(
                  icon: Icon(
                    widget.controller.videoController!.value.volume > 0
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.controller.videoController!.value.volume > 0) {
                      widget.controller.videoController!.setVolume(0);
                    } else {
                      widget.controller.videoController!.setVolume(1.0);
                    }
                  },
                ),

                // Exit Fullscreen Button
                IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () async {
                    await _setPortraitOrientation();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final duration = widget.controller.duration.value.inMilliseconds.toDouble();
      final position = widget.controller.position.value.inMilliseconds.toDouble();

      return SliderTheme(
        data: SliderThemeData(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
        child: Slider(
          value: position,
          min: 0,
          max: duration,
          onChanged: (value) {
            widget.controller.seekTo(Duration(milliseconds: value.toInt()));
          },
          activeColor: Colors.red,
          inactiveColor: Colors.white24,
        ),
      );
    });
  }

  Widget _buildTimeText() {
    return Obx(() => Text(
          _formatDuration(widget.controller.position.value),
          style: const TextStyle(color: Colors.white),
        ));
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
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.localPath.value.isEmpty) {
            return Container(
              height: 400,
              child: const Center(child: Text('No training material available')),
            );
          }

          return GestureDetector(
            onTap: () => _showFullScreenPDF(context, controller.localPath.value),
            child: Container(
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
                  _buildPdfOverlayControls(context, controller),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // PDF overlay controls
  Widget _buildPdfOverlayControls(BuildContext context, CachedPdfController controller) {
    return Positioned(
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
            IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: () => _showFullScreenPDF(context, controller.localPath.value),
            ),
          ],
        ),
      ),
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
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
