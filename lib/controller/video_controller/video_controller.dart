import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../support_data_controller.dart';

// Custom Video Player Controller
class VideoController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  late VideoPlayerController videoController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var duration = const Duration().obs;
  var position = const Duration().obs;
  var urlVideo = "".obs;

  @override
  void onInit() {
    super.onInit();
    try {
      urlVideo.value = supportController.getKnowledge().first['path_video'];
      print('Video URL: ${urlVideo.value}'); // Add this line to check URL

      if (urlVideo.value.isEmpty) {
        print('Video URL is empty');
        return;
      }

      // Make sure URL starts with http:// or https://
      // if (!urlVideo.value.startsWith('http://') && !urlVideo.value.startsWith('https://')) {
      //   urlVideo.value = 'https://dev-cetaphil.i-am.host${urlVideo.value}';
      // }
      urlVideo.value = 'https://dev-cetaphil.i-am.host/storage${urlVideo.value}';

      final uri = Uri.parse(urlVideo.value);
      if (!uri.isAbsolute) {
        print('Invalid video URL format');
        return;
      }
      initializeVideo();
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void initializeVideo() {
    videoController = VideoPlayerController.network(
      urlVideo.value,
    )..initialize().then((_) {
      duration.value = videoController.value.duration;
      isInitialized.value = true;
      update();
    }).catchError((error) {
      print('Video Error: $error');
      isInitialized.value = false;
      // Handle error - maybe show a message to user
      update();
    });

    videoController.addListener(() {
      position.value = videoController.value.position;
      update();
    });
  }

  void playPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
      isPlaying.value = false;
    } else {
      videoController.play();
      isPlaying.value = true;
    }
    update();
  }

  void seekTo(Duration position) {
    videoController.seekTo(position);
  }

  @override
  void onClose() {
    videoController.dispose();
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

        if (controller.videoController.value.hasError) {
          return const Center(
            child: Text('Error loading video. Please try again later.'),
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
                        controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
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
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }
}