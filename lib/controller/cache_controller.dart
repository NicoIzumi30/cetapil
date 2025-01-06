import 'dart:async';
import 'dart:io';

import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<VideoScaffold> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CachedVideoController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  final _cacheManager = DefaultCacheManager();
  static const _cacheKey = 'video_cache';

  late VideoPlayerController videoController;

  // Observable states
  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final duration = const Duration().obs;
  final position = const Duration().obs;
  final urlVideo = "".obs;
  final showControls = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isFullscreen = false.obs;

  // Private variables
  Timer? _positionTimer;
  Timer? _hideControlsTimer;
  File? _cachedVideoFile;

  @override
  void onInit() {
    super.onInit();
    _initVideoController();
  }

  void _initVideoController() {
    videoController = VideoPlayerController.network('');
    initializeVideo();
  }

  Future<File> _getCachedVideo(String url) async {
    try {
      // Try to get from cache first
      final cachedFile = await _cacheManager.getFileFromCache(_cacheKey);
      if (cachedFile != null && await cachedFile.file.exists()) {
        return cachedFile.file;
      }

      // Download if not in cache
      final downloadedFile = await _cacheManager.downloadFile(url, key: _cacheKey);
      return downloadedFile.file;
    } catch (e) {
      // Fallback to direct download if cache fails
      final fallbackFile = await _cacheManager.downloadFile(url, key: _cacheKey);
      return fallbackFile.file;
    }
  }

  Future<void> initializeVideo() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final url = supportController.getKnowledge().first['path_video'];
      if (url.isEmpty) {
        throw Exception('Video URL is empty');
      }

      final fullUrl = 'https://dev-cetaphil.i-am.host/storage$url';

      // Reset cache if URL changed
      if (urlVideo.value != fullUrl) {
        await _cacheManager.removeFile(_cacheKey);
      }

      urlVideo.value = fullUrl;
      await _cleanup();

      try {
        // Try to load from cache first
        _cachedVideoFile = await _getCachedVideo(fullUrl);
        await videoController.dispose();
        videoController = VideoPlayerController.file(_cachedVideoFile!);
        await videoController.initialize();
      } catch (e) {
        // Fallback to network URL if cache fails
        await videoController.dispose();
        videoController = VideoPlayerController.networkUrl(Uri.parse(fullUrl));
        await videoController.initialize();
      }

      if (videoController.value.isInitialized) {
        duration.value = videoController.value.duration;
        videoController.addListener(_videoListener);
        _startPositionTimer();
        isInitialized.value = true;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isInitialized.value = false;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    _hideControlsTimer?.cancel();

    if (showControls.value && isPlaying.value) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
    }
  }

  void _videoListener() {
    if (!isInitialized.value) return;
    
    isPlaying.value = videoController.value.isPlaying;
    position.value = videoController.value.position;
    
    // Auto-hide controls when playing
    if (isPlaying.value && showControls.value) {
      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
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
      showControls.value = true;
      _hideControlsTimer?.cancel();
    } else {
      videoController.play();
      if (showControls.value) {
        _hideControlsTimer?.cancel();
        _hideControlsTimer = Timer(const Duration(seconds: 3), () {
          showControls.value = false;
        });
      }
    }
    update();
  }

  void seekTo(Duration position) {
    if (!isInitialized.value) return;
    videoController.seekTo(position);
    this.position.value = position;
    update();
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (isFullscreen.value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    update();
  }

  Future<void> _cleanup() async {
    _positionTimer?.cancel();
    _hideControlsTimer?.cancel();
    if (isInitialized.value) {
      await videoController.dispose();
      isInitialized.value = false;
      isPlaying.value = false;
    }
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
}
