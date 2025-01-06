import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../support_data_controller.dart';

// Custom Video Player Controller
class VideoController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  VideoPlayerController? videoController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var duration = const Duration().obs;
  var position = const Duration().obs;
  var urlVideo = "".obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      // Try to get the video URL safely
      final knowledgeList = supportController.getKnowledge();
      if (knowledgeList.isEmpty) {
        print('No knowledge data available');
        hasError.value = true;
        return;
      }

      urlVideo.value = knowledgeList.first['path_video'] ?? '';
      print('Video URL: ${urlVideo.value}');

      if (urlVideo.value.isEmpty) {
        print('Video URL is empty');
        hasError.value = true;
        return;
      }

      urlVideo.value = 'https://dev-cetaphil.i-am.host/storage${urlVideo.value}';

      final uri = Uri.parse(urlVideo.value);
      if (!uri.isAbsolute) {
        print('Invalid video URL format');
        hasError.value = true;
        return;
      }

      initializeVideo();
    } catch (e) {
      print('Error initializing video: $e');
      hasError.value = true;
    }
  }

  void initializeVideo() {
    try {
      videoController = VideoPlayerController.network(urlVideo.value)
        ..initialize().then((_) {
          duration.value = videoController?.value.duration ?? Duration.zero;
          isInitialized.value = true;
          update();
        }).catchError((error) {
          print('Video Error: $error');
          isInitialized.value = false;
          hasError.value = true;
          update();
        });

      videoController?.addListener(() {
        position.value = videoController?.value.position ?? Duration.zero;
        update();
      });
    } catch (e) {
      print('Error in initializeVideo: $e');
      hasError.value = true;
    }
  }

  void playPause() {
    if (videoController == null) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
    } else {
      videoController!.play();
      isPlaying.value = true;
    }
    update();
  }

  void seekTo(Duration position) {
    videoController?.seekTo(position);
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}

class CustomVideoPlayer extends StatelessWidget {
  const CustomVideoPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      init: VideoController(),
      builder: (controller) {
        if (controller.hasError.value) {
          return const Center(
            child: Text('No video available or error loading video.'),
          );
        }

        if (!controller.isInitialized.value || controller.videoController == null) {
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

        if (controller.videoController!.value.hasError) {
          return const Center(
            child: Text('Error loading video. Please try again later.'),
          );
        }

        return Column(
          children: [
            // Video display
            AspectRatio(
              aspectRatio: controller.videoController!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(controller.videoController!),
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
