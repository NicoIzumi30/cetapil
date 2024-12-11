import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class KnowledgeCacheManager {
  static const Duration cacheValidDuration = Duration(days: 7);

  static String _generateCacheKey(String url, String channel) {
    final bytes = utf8.encode('$url-$channel');
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<File?> _getCachedFile(String url, String channel, String extension) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final fileName = '${_generateCacheKey(url, channel)}.$extension';
      final file = File('${cacheDir.path}/$fileName');

      if (await file.exists()) {
        final fileStats = await file.stat();
        final age = DateTime.now().difference(fileStats.modified);
        
        if (age < cacheValidDuration) {
          return file;
        }
      }
      return null;
    } catch (e) {
      print('Cache check error: $e');
      return null;
    }
  }

  static Future<String?> getCachedPath(String url, String channel, String extension) async {
    if (url.isEmpty) return null;

    try {
      // Check cache first
      final cachedFile = await _getCachedFile(url, channel, extension);
      if (cachedFile != null) {
        print('Using cached file: ${cachedFile.path}');
        return cachedFile.path;
      }

      // Download if not cached
      final file = await _downloadAndCache(url, channel, extension);
      return file?.path;
    } catch (e) {
      print('Error getting cached path: $e');
      return null;
    }
  }

  static Future<File?> _downloadAndCache(String url, String channel, String extension) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final cacheDir = await getTemporaryDirectory();
        final fileName = '${_generateCacheKey(url, channel)}.$extension';
        final file = File('${cacheDir.path}/$fileName');
        
        await file.writeAsBytes(response.bodyBytes);
        print('File cached at: ${file.path}');
        return file;
      }
      return null;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = cacheDir.listSync();
      
      for (var file in files) {
        if (file is File) {
          final stats = await file.stat();
          final age = DateTime.now().difference(stats.modified);
          
          if (age > cacheValidDuration) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      print('Cache clearing error: $e');
    }
  }
}