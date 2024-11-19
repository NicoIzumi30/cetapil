import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

// Custom Video Player Controller
class VideoController extends GetxController {
  late VideoPlayerController videoController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var duration = const Duration().obs;
  var position = const Duration().obs;

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  void initializeVideo() {
    // For network video
    videoController = VideoPlayerController.network(
      'https://youtu.be/HInw_hiVtQE?si=YqPJ0V8Rt03w2bE7',
      // Or for local asset
      // VideoPlayerController.asset('assets/video.mp4'),
      // Or for local file
      // VideoPlayerController.file(File('path/to/video.mp4')),
    )..initialize().then((_) {
      duration.value = videoController.value.duration;
      isInitialized.value = true;
      update();
    });

    // Add listener for position updates
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
          return const Center(child: CircularProgressIndicator());
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