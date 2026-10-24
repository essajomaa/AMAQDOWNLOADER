import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../theme/app_theme.dart';
import '../widgets/quality_bottom_sheet.dart';

class BrowserScreen extends StatefulWidget {
  final String initialUrl;
  const BrowserScreen({Key? key, this.initialUrl = 'https://m.youtube.com'}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  InAppWebViewController? _webViewController;
  final TextEditingController _urlController = TextEditingController();
  double _progress = 0;
  bool _hasDetectedMedia = false;
  String _pageTitle = '';
  String _detectedMediaUrl = '';

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.initialUrl;
  }

  void _onMediaDetected(String mediaUrl) {
    if (!_hasDetectedMedia) {
      setState(() {
        _hasDetectedMedia = true;
        _detectedMediaUrl = mediaUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          titleSpacing: 8,
          title: Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF07182B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF132F4C)),
            ),
            child: TextField(
              controller: _urlController,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ابحث أو أدخل رابط موقع...',
                prefixIcon: Icon(Icons.lock, color: AmaqColors.signalCyan, size: 14),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onSubmitted: (val) {
                var url = val.trim();
                if (!url.startsWith('http://') && !url.startsWith('https://')) {
                  url = 'https://www.google.com/search?q=$url';
                }
                _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () => _webViewController?.reload(),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              useShouldInterceptRequest: true,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _urlController.text = url?.toString() ?? '';
                _hasDetectedMedia = false;
              });
            },
            onLoadStop: (controller, url) async {
              final title = await controller.getTitle();
              setState(() {
                _pageTitle = title ?? 'فيديو بدون عنوان';
                _urlController.text = url?.toString() ?? '';
              });

              // Check if URL is YouTube / Facebook / Insta video
              final urlStr = url?.toString() ?? '';
              if (urlStr.contains('watch?v=') || urlStr.contains('/reel/') || urlStr.contains('/video/')) {
                _onMediaDetected(urlStr);
              }
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            shouldInterceptRequest: (controller, request) async {
              final reqUrl = request.url.toString();
              if (reqUrl.contains('.mp4') || reqUrl.contains('googlevideo.com/videoplayback') || reqUrl.contains('.m3u8')) {
                _onMediaDetected(reqUrl);
              }
              return null;
            },
          ),

          // Loading Progress Bar
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AmaqColors.signalCyan),
              minHeight: 2.5,
            ),

          // SnapTube-Style Floating Download Button (Amaq Glow)
          if (_hasDetectedMedia)
            Positioned(
              bottom: 24,
              left: 24,
              child: FloatingActionButton.extended(
                backgroundColor: AmaqColors.signalCyan,
                foregroundColor: AmaqColors.midnightDark,
                elevation: 8,
                icon: const Icon(Icons.download, size: 24),
                label: const Text(
                  'تحميل الفيديو',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () {
                  QualityBottomSheet.show(
                    context,
                    title: _pageTitle.isNotEmpty ? _pageTitle : 'فيديو من المتصفح',
                    sourceUrl: _urlController.text,
                    directStreamUrl: _detectedMediaUrl.isNotEmpty ? _detectedMediaUrl : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
