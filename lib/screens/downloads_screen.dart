import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../models/download_item.dart';
import '../services/download_service.dart';
import '../theme/app_theme.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DownloadService _service = DownloadService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _service.activeDownloads;
    final completed = _service.completedDownloads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة التنزيلات'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AmaqColors.signalCyan,
          indicatorWeight: 3,
          labelColor: AmaqColors.signalCyan,
          unselectedLabelColor: AmaqColors.slateText,
          tabs: [
            Tab(text: 'جاري التحميل (${active.length})'),
            Tab(text: 'المكتملة (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Tab
          active.isEmpty
              ? _emptyState(
                  icon: Icons.download_done,
                  title: 'لا توجد تحميلات نشطة حالياً',
                  subtitle: 'تصفح أي فيديو أو ألصق رابطه للبدء فوراً',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: active.length,
                  itemBuilder: (ctx, i) => _activeDownloadCard(active[i]),
                ),

          // Completed Tab
          completed.isEmpty
              ? _emptyState(
                  icon: Icons.folder_open,
                  title: 'لم تكتمل أي تحميلات بعد',
                  subtitle: 'الملفات المكتملة ستظهر هنا لتشغيلها ومشاركتها',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completed.length,
                  itemBuilder: (ctx, i) => _completedDownloadCard(completed[i]),
                ),
        ],
      ),
    );
  }

  Widget _activeDownloadCard(DownloadItem item) {
    return Container(
      margin: const EdgeInsets.bottom(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AmaqColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AmaqColors.primaryNavy),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AmaqColors.primaryNavy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.mediaType == MediaType.audio ? Icons.music_note : Icons.movie,
                  color: AmaqColors.signalCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.speedMBs.toStringAsFixed(1)} MB/s • ${item.formattedDownloaded} / ${item.formattedSize}',
                      style: const TextStyle(fontSize: 11, color: AmaqColors.slateText),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  item.status == DownloadStatus.paused ? Icons.play_arrow : Icons.pause,
                  color: AmaqColors.signalCyan,
                  size: 22,
                ),
                onPressed: () => _service.pauseDownload(item.id),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                onPressed: () => _service.cancelDownload(item.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF061525),
              valueColor: const AlwaysStoppedAnimation<Color>(AmaqColors.signalCyan),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(item.progress * 100).toInt()}%',
                style: const TextStyle(fontSize: 11, color: AmaqColors.signalCyan, fontWeight: FontWeight.bold),
              ),
              Text(
                item.quality,
                style: const TextStyle(fontSize: 10, color: AmaqColors.slateText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedDownloadCard(DownloadItem item) {
    return Container(
      margin: const EdgeInsets.bottom(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AmaqColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF132F4C)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AmaqColors.successEmerald.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.mediaType == MediaType.audio ? Icons.audiotrack : Icons.play_arrow,
              color: AmaqColors.successEmerald,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.quality} • ${item.formattedSize}',
                  style: const TextStyle(fontSize: 11, color: AmaqColors.slateText),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AmaqColors.signalCyan, size: 20),
            onPressed: () {
              Share.shareXFiles([XFile(item.savePath)], text: item.title);
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white, size: 20),
            onPressed: () {
              OpenFilex.open(item.savePath);
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: AmaqColors.slateText.withOpacity(0.5)),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AmaqColors.slateText),
            ),
          ],
        ),
      ),
    );
  }
}
