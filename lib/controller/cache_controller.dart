import 'dart:async';
import 'dart:io';

import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class CachedPdfController extends GetxController {
  static const _cacheKey = 'pdf_cache';
  final _cacheManager = DefaultCacheManager();

  final isInitialized = false.obs;
  final isLoading = false.obs;
  final localPath = "".obs;
  final currentPage = 0.obs;
  final totalPages = 0.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initPdf();
  }

  Future<void> initPdf() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final url = 'https://dev.cetaphil.id/storage${Get.find<KnowledgeController>().pdfPath}';

      // Check cache first
      final fileInfo = await _cacheManager.getFileFromCache(_cacheKey);
      if (fileInfo != null && await fileInfo.file.exists()) {
        localPath.value = fileInfo.file.path;
        isInitialized.value = true;
      } else {
        final downloadedFile = await _cacheManager.downloadFile(
          url,
          key: _cacheKey,
          force: true,
        );
        localPath.value = downloadedFile.file.path;
        isInitialized.value = true;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('PDF initialization error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> clearCache() async {
    await _cacheManager.removeFile(_cacheKey);
    await initPdf();
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
  static const _cacheKey = 'video_cache';
  final _cacheManager = DefaultCacheManager();

  // Make controller nullable instead of late
  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final duration = const Duration().obs;
  final position = const Duration().obs;
  final showControls = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isFullscreen = false.obs;

  Timer? _positionTimer;
  Timer? _hideControlsTimer;
  File? _cachedVideoFile;

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final url =
          'https://dev.cetaphil.id/storage${Get.find<KnowledgeController>().videoPath}'; // Replace with actual URL

      // Check cache first
      try {
        final fileInfo = await _cacheManager.getFileFromCache(_cacheKey);
        if (fileInfo != null && await fileInfo.file.exists()) {
          _cachedVideoFile = fileInfo.file;
        } else {
          final downloadedFile = await _cacheManager.downloadFile(
            url,
            key: _cacheKey,
            force: true,
          );
          _cachedVideoFile = downloadedFile.file;
        }
      } catch (e) {
        throw Exception('Failed to load video from cache: ${e.toString()}');
      }

      if (_cachedVideoFile == null) {
        throw Exception('Failed to load video file');
      }

      await _cleanup();

      try {
        _videoController = VideoPlayerController.file(_cachedVideoFile!);
        await _videoController!.initialize();
      } catch (e) {
        throw Exception('Failed to initialize video player: ${e.toString()}');
      }

      if (_videoController?.value.isInitialized ?? false) {
        duration.value = _videoController!.value.duration;
        _videoController!.addListener(_videoListener);
        _startPositionTimer();
        isInitialized.value = true;
      } else {
        throw Exception('Video player initialization failed');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Video initialization error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _videoListener() {
    if (_videoController == null) return;

    isPlaying.value = _videoController!.value.isPlaying;
    position.value = _videoController!.value.position;

    if (isPlaying.value && showControls.value) {
      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
    }
  }

  void toggleControls() {
    if (!isInitialized.value) return;

    showControls.value = !showControls.value;
    _hideControlsTimer?.cancel();
    if (showControls.value && isPlaying.value) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
    }
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isInitialized.value && !(_videoController?.value.isCompleted ?? true)) {
        position.value = _videoController!.value.position;
      }
    });
  }

  void playPause() {
    if (!isInitialized.value || _videoController == null) return;

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      showControls.value = true;
      _hideControlsTimer?.cancel();
    } else {
      _videoController!.play();
      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
    }
  }

  void seekTo(Duration position) {
    if (!isInitialized.value || _videoController == null) return;
    _videoController!.seekTo(position);
    this.position.value = position;
  }

  Future<void> _cleanup() async {
    _positionTimer?.cancel();
    _hideControlsTimer?.cancel();
    if (_videoController != null) {
      await _videoController!.dispose();
      _videoController = null;
      isInitialized.value = false;
      isPlaying.value = false;
    }
  }

  Future<void> clearCache() async {
    await _cacheManager.removeFile(_cacheKey);
    await initializeVideo();
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
}
