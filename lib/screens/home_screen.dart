import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/quality_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final Function(String url) onOpenBrowserWithUrl;
  const HomeScreen({Key? key, required this.onOpenBrowserWithUrl}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'يوتيوب',
      'url': 'https://m.youtube.com',
      'icon': Icons.play_circle_filled,
      'color': const Color(0xFFFF0000),
    },
    {
      'name': 'فيسبوك',
      'url': 'https://m.facebook.com',
      'icon': Icons.facebook,
      'color': const Color(0xFF1877F2),
    },
    {
      'name': 'إنستغرام',
      'url': 'https://www.instagram.com',
      'icon': Icons.camera_alt,
      'color': const Color(0xFFE4405F),
    },
    {
      'name': 'تيك توك',
      'url': 'https://www.tiktok.com',
      'icon': Icons.music_note,
      'color': const Color(0xFF00F2FE),
    },
    {
      'name': 'إكس / تويتر',
      'url': 'https://twitter.com',
      'icon': Icons.chat_bubble,
      'color': const Color(0xFF1DA1F2),
    },
    {
      'name': 'ساوند كلاود',
      'url': 'https://soundcloud.com',
      'icon': Icons.graphic_eq,
      'color': const Color(0xFFFF5500),
    },
    {
      'name': 'بينترست',
      'url': 'https://www.pinterest.com',
      'icon': Icons.push_pin,
      'color': const Color(0xFFE60023),
    },
    {
      'name': 'ديلي موشن',
      'url': 'https://www.dailymotion.com',
      'icon': Icons.video_library,
      'color': const Color(0xFF0066DC),
    },
  ];

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text != null && data.text!.isNotEmpty) {
      setState(() {
        _urlController.text = data.text!.trim();
      });
      _handleDownloadUrl(_urlController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الحافظة فارغة! انسخ رابط فيديو أولاً.')),
      );
    }
  }

  void _handleDownloadUrl(String url) {
    if (url.trim().isEmpty) return;
    QualityBottomSheet.show(
      context,
      title: 'فيديو مختار للتنزيل الفوري',
      sourceUrl: url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search & Paste Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AmaqColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AmaqColors.primaryNavy),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ألصق رابط الفيديو من يوتيوب، فيس، تيك توك...',
                        prefixIcon: const Icon(Icons.search, color: AmaqColors.slateText, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.content_paste, color: AmaqColors.signalCyan, size: 20),
                          onPressed: _pasteFromClipboard,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.paste, size: 16, color: AmaqColors.signalCyan),
                            label: const Text('لصق من الحافظة', style: TextStyle(fontSize: 12, color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF132F4C)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _pasteFromClipboard,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('تنزيل فوري', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () => _handleDownloadUrl(_urlController.text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Supported Platforms Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'المنصات والمواقع المدعومة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'أكثر من 1000 منصة',
                    style: TextStyle(fontSize: 11, color: AmaqColors.signalCyan),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: _platforms.length,
                itemBuilder: (context, idx) {
                  final p = _platforms[idx];
                  return InkWell(
                    onTap: () => widget.onOpenBrowserWithUrl(p['url']),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AmaqColors.midnightSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AmaqColors.primaryNavy.withOpacity(0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (p['color'] as Color).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(p['icon'], color: p['color'], size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p['name'],
                            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),

              // Amaq Telecom Brand Guarantee Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AmaqColors.primaryNavy, AmaqColors.midnightDark],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AmaqColors.signalCyan.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.verified, color: AmaqColors.signalCyan, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'مزايا حصرية لنسخة AMAQDOWNLOADER',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _benefitPill('✓ بدون إعلانات نهائياً'),
                        const SizedBox(width: 8),
                        _benefitPill('✓ جودة 4K & 1080p'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _benefitPill('✓ تحويل مباشر لـ MP3'),
                        const SizedBox(width: 8),
                        _benefitPill('✓ سرعة تنزيل فائقة x8'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitPill(String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF051323),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF132F4C)),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AmaqColors.skyTower, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
