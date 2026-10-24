enum DownloadStatus { pending, downloading, paused, completed, error }
enum MediaType { video, audio }

class DownloadItem {
  final String id;
  final String title;
  final String sourceUrl;
  final String downloadUrl;
  final String quality;
  final MediaType mediaType;
  final String savePath;
  int totalBytes;
  int downloadedBytes;
  double speedMBs;
  DownloadStatus status;
  String? errorMessage;

  DownloadItem({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.downloadUrl,
    required this.quality,
    required this.mediaType,
    required this.savePath,
    this.totalBytes = 0,
    this.downloadedBytes = 0,
    this.speedMBs = 0.0,
    this.status = DownloadStatus.pending,
    this.errorMessage,
  });

  double get progress {
    if (totalBytes <= 0) return 0.0;
    return (downloadedBytes / totalBytes).clamp(0.0, 1.0);
  }

  String get formattedSize {
    if (totalBytes <= 0) return 'جاري الحساب...';
    final mb = totalBytes / (1024 * 1024);
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(1)} GB';
    }
    return '${mb.toStringAsFixed(1)} MB';
  }

  String get formattedDownloaded {
    final mb = downloadedBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}
