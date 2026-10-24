import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_item.dart';

class DownloadService extends ChangeNotifier {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final List<DownloadItem> _items = [];
  final Map<String, CancelToken> _cancelTokens = {};
  final Dio _dio = Dio();

  List<DownloadItem> get allItems => List.unmodifiable(_items);
  List<DownloadItem> get activeDownloads =>
      _items.where((i) => i.status == DownloadStatus.downloading || i.status == DownloadStatus.pending).toList();
  List<DownloadItem> get completedDownloads =>
      _items.where((i) => i.status == DownloadStatus.completed).toList();

  Future<void> startDownload({
    required String title,
    required String sourceUrl,
    required String downloadUrl,
    required String quality,
    required MediaType mediaType,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Get Android Download directory
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/AMAQDOWNLOADER');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final ext = mediaType == MediaType.audio ? 'mp3' : 'mp4';
    final cleanTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final filePath = '${dir.path}/${cleanTitle}_$quality.$ext';

    final item = DownloadItem(
      id: id,
      title: title,
      sourceUrl: sourceUrl,
      downloadUrl: downloadUrl,
      quality: quality,
      mediaType: mediaType,
      savePath: filePath,
      status: DownloadStatus.downloading,
    );

    _items.insert(0, item);
    notifyListeners();

    final cancelToken = CancelToken();
    _cancelTokens[id] = cancelToken;

    int lastBytes = 0;
    DateTime lastTime = DateTime.now();

    try {
      await _dio.download(
        downloadUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            item.totalBytes = total;
            item.downloadedBytes = received;

            final now = DateTime.now();
            final elapsedSec = now.difference(lastTime).inMilliseconds / 1000.0;
            if (elapsedSec >= 0.5) {
              final bytesDiff = received - lastBytes;
              item.speedMBs = (bytesDiff / (1024 * 1024)) / elapsedSec;
              lastBytes = received;
              lastTime = now;
              notifyListeners();
            }
          }
        },
      );

      item.status = DownloadStatus.completed;
      item.speedMBs = 0.0;
      notifyListeners();
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        item.status = DownloadStatus.paused;
      } else {
        item.status = DownloadStatus.error;
        item.errorMessage = e.toString();
      }
      notifyListeners();
    } finally {
      _cancelTokens.remove(id);
    }
  }

  void pauseDownload(String id) {
    if (_cancelTokens.containsKey(id)) {
      _cancelTokens[id]?.cancel();
      _cancelTokens.remove(id);
    }
    final item = _items.firstWhere((i) => i.id == id);
    item.status = DownloadStatus.paused;
    notifyListeners();
  }

  void cancelDownload(String id) {
    if (_cancelTokens.containsKey(id)) {
      _cancelTokens[id]?.cancel();
      _cancelTokens.remove(id);
    }
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}
