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
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var duration = const Duration().obs;
  var position = const Duration().obs;
  var urlVideo = "".obs;

  static const _cacheKey = 'video_cache';
  final _cacheManager = DefaultCacheManager();

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      urlVideo.value = supportController.getKnowledge().first['path_video'];
      if (urlVideo.value.isEmpty) {
        print('Video URL is empty');
        return;
      }

      final url = 'https://dev-cetaphil.i-am.host/storage${urlVideo.value}';

      // Try to get from cache first
      final fileInfo = await _cacheManager.getFileFromCache(_cacheKey);
      File videoFile;

      if (fileInfo != null && fileInfo.file.existsSync()) {
        videoFile = fileInfo.file;
      } else {
        // Download and cache if not found
        final downloadedFile = await _cacheManager.downloadFile(
          url,
          key: _cacheKey,
        );
        videoFile = downloadedFile.file;
      }

      // Initialize video player with cached file
      videoController = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          duration.value = videoController.value.duration;
          isInitialized.value = true;
          update();
        }).catchError((error) {
          print('Video Error: $error');
          isInitialized.value = false;
          update();
        });

      videoController.addListener(() {
        position.value = videoController.value.position;
        update();
      });
    } catch (e) {
      print('Error initializing video: $e');
      isInitialized.value = false;
      update();
    }
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
    _cacheManager.emptyCache(); // Optional: clear cache when controller is disposed
    super.onClose();
  }
}
