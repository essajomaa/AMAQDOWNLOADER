import 'package:flutter/material.dart';
import '../models/download_item.dart';
import '../services/download_service.dart';
import '../theme/app_theme.dart';

class QualityBottomSheet extends StatefulWidget {
  final String title;
  final String sourceUrl;
  final String? directStreamUrl;

  const QualityBottomSheet({
    Key? key,
    required this.title,
    required this.sourceUrl,
    this.directStreamUrl,
  }) : super(key: key);

  static void show(BuildContext context, {
    required String title,
    required String sourceUrl,
    String? directStreamUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QualityBottomSheet(
        title: title,
        sourceUrl: sourceUrl,
        directStreamUrl: directStreamUrl,
      ),
    );
  }

  @override
  State<QualityBottomSheet> createState() => _QualityBottomSheetState();
}

class _QualityBottomSheetState extends State<QualityBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startDownload(String quality, MediaType type) {
    Navigator.pop(context);
    
    // In production, directStreamUrl comes from yt-dlp sniffer or stream interceptor
    final streamUrl = widget.directStreamUrl ?? widget.sourceUrl;

    DownloadService().startDownload(
      title: widget.title,
      sourceUrl: widget.sourceUrl,
      downloadUrl: streamUrl,
      quality: quality,
      mediaType: type,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AmaqColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.downloading, color: AmaqColors.signalCyan),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'بدأ تحميل "$quality" بدون إعلانات',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AmaqColors.midnightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AmaqColors.signalCyan, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AmaqColors.slateText.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AmaqColors.primaryNavy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.download, color: AmaqColors.signalCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Text(
                      'اختر الدقة المطلوبة للتنزيل الفوري',
                      style: TextStyle(color: AmaqColors.slateText, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AmaqColors.slateText, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 14),

          // Tabs
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF061525),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AmaqColors.primaryNavy,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AmaqColors.signalCyan.withOpacity(0.5)),
              ),
              labelColor: AmaqColors.signalCyan,
              unselectedLabelColor: AmaqColors.slateText,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'فيديو (MP4)'),
                Tab(text: 'صوت فقط (MP3)'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quality options
          SizedBox(
            height: 180,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Video Qualities Grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _qualityCard('1080p Full HD', '120 MB', MediaType.video, isHigh: true),
                    _qualityCard('720p HD', '55 MB', MediaType.video),
                    _qualityCard('480p SD', '28 MB', MediaType.video),
                    _qualityCard('360p اقتصادي', '14 MB', MediaType.video),
                  ],
                ),

                // Audio Qualities Grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _qualityCard('MP3 (320 kbps)', '8.5 MB', MediaType.audio, isHigh: true),
                    _qualityCard('MP3 (128 kbps)', '3.4 MB', MediaType.audio),
                    _qualityCard('M4A High', '4.2 MB', MediaType.audio),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Guarantee
          const Center(
            child: Text(
              '⚡ يتم التنزيل مباشرة بدون إعلانات وبأعلى سرعة ممكنة',
              style: TextStyle(color: AmaqColors.skyTower, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qualityCard(String quality, String size, MediaType type, {bool isHigh = false}) {
    return InkWell(
      onTap: () => _startDownload(quality, type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF061525),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHigh ? AmaqColors.signalCyan.withOpacity(0.6) : const Color(0xFF132F4C),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  quality,
                  style: TextStyle(
                    color: isHigh ? AmaqColors.signalCyan : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(size, style: const TextStyle(color: AmaqColors.slateText, fontSize: 11)),
              ],
            ),
            const Icon(Icons.arrow_downward, color: AmaqColors.signalCyan, size: 16),
          ],
        ),
      ),
    );
  }
}
