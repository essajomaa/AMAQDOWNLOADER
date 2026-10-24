import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'browser_screen.dart';
import 'downloads_screen.dart';
import 'settings_screen.dart';
import '../theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _browserUrl = 'https://m.youtube.com';

  void _openBrowserWithUrl(String url) {
    setState(() {
      _browserUrl = url;
      _currentIndex = 1; // switch to Browser tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onOpenBrowserWithUrl: _openBrowserWithUrl),
      BrowserScreen(key: ValueKey(_browserUrl), initialUrl: _browserUrl),
      const DownloadsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Row(
                children: [
                  Image.asset('assets/images/icon_dark.png', width: 32, height: 32),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'AMAQDOWNLOADER',
                        style: TextStyle(fontWeight: FontWeight.black, fontSize: 15, letterSpacing: 0.5),
                      ),
                      Text(
                        'أعماق للاتصالات • بدون إعلانات',
                        style: TextStyle(fontSize: 9, color: AmaqColors.skyTower),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.download, color: AmaqColors.signalCyan),
                  onPressed: () => setState(() => _currentIndex = 2),
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language_outlined),
            activeIcon: Icon(Icons.language),
            label: 'المتصفح',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            activeIcon: Icon(Icons.download),
            label: 'التنزيلات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
