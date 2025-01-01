import 'dart:async';
import 'dart:io';

import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class CachedPdfController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  var isInitialized = false.obs;
  var isLoading = false.obs;
  var urlPdf = "".obs;
  var localPath = "".obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;

  static const _cacheKey = 'pdf_cache';
  final _cacheManager = DefaultCacheManager();

  @override
  void onInit() {
    super.onInit();
    initPdf();
  }

  Future<void> initPdf() async {
    try {
      isLoading.value = true;
      urlPdf.value = supportController.getKnowledge().first['path_pdf'];
      if (urlPdf.value.isEmpty) {
        print('PDF URL is empty');
        return;
      }

      final url = 'https://dev-cetaphil.i-am.host/storage${urlPdf.value}';

      // Try to get file from cache first
      final fileInfo = await _cacheManager.getFileFromCache(_cacheKey);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        localPath.value = fileInfo.file.path;
        isLoading.value = false;
        return;
      }

      // If not in cache, download and cache it
      final file = await _cacheManager.downloadFile(
        url,
        key: _cacheKey,
      );

      localPath.value = file.file.path;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error loading PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class CachedVideoController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  late VideoPlayerController videoController;
  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final duration = const Duration().obs;
  final position = const Duration().obs;
  final urlVideo = "".obs;
  Timer? _positionTimer;

  static const _cacheKey = 'video_cache';
  final _cacheManager = DefaultCacheManager();

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
    
      String url = supportController.getKnowledge().first['path_video'];
      if (url.isEmpty) return;

      urlVideo.value = 'https://dev-cetaphil.i-am.host/storage${url}';
      if (urlVideo.value.isEmpty) return;

      final fileInfo = await _cacheManager.getFileFromCache(_cacheKey);
      File videoFile;

      if (fileInfo != null && fileInfo.file.existsSync()) {
        videoFile = fileInfo.file;
        videoController = VideoPlayerController.file(
          videoFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      } else {
        final downloadedFile = await _cacheManager.downloadFile(urlVideo.value, key: _cacheKey);
        videoFile = downloadedFile.file;
        videoController = VideoPlayerController.file(
          videoFile,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      await _cleanup();
      await videoController.initialize();
      duration.value = videoController.value.duration;
      videoController.addListener(_videoListener);
      _startPositionTimer();

      isInitialized.value = true;
      update();
    } catch (e) {
      print('Error initializing video: $e');
      isInitialized.value = false;
      update();
    }
  }

  void _videoListener() {
    if (!isInitialized.value) return;
    final playing = videoController.value.isPlaying;
    if (playing != isPlaying.value) {
      isPlaying.value = playing;
    }
    position.value = videoController.value.position;
    if (duration.value != videoController.value.duration) {
      duration.value = videoController.value.duration;
    }
    update();
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isInitialized.value && !videoController.value.isCompleted) {
        position.value = videoController.value.position;
        update();
      }
    });
  }

  void playPause() {
    if (!isInitialized.value) return;
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
    isPlaying.value = videoController.value.isPlaying;
    update();
  }

  void seekTo(Duration position) {
    if (!isInitialized.value) return;
    videoController.seekTo(position);
    this.position.value = position;
    update();
  }

  void pauseVideo() {
    if (isInitialized.value && videoController.value.isPlaying) {
      videoController.pause();
      isPlaying.value = false;
      update();
    }
  }

  Future<void> _cleanup() async {
    _positionTimer?.cancel();
    if (isInitialized.value) {
      videoController.removeListener(_videoListener);
      await videoController.pause();
      await videoController.dispose();
      isInitialized.value = false;
      isPlaying.value = false;
    }
  }

  @override
  void onClose() {
    _cleanup();
    _cacheManager.emptyCache();
    super.onClose();
  }
}
