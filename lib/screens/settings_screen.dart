import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _wifiOnly = false;
  int _maxConcurrent = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Storage
          _sectionTitle('التخزين والتحميل'),
          _tile(
            icon: Icons.folder,
            title: 'مسار حفظ الملفات',
            subtitle: '/Download/AMAQDOWNLOADER',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AmaqColors.slateText),
            onTap: () {},
          ),
          SwitchListTile(
            value: _wifiOnly,
            activeColor: AmaqColors.signalCyan,
            title: const Text('التحميل عبر Wi-Fi فقط', style: TextStyle(fontSize: 13, color: Colors.white)),
            subtitle: const Text('توفير باقة بيانات الجوال', style: TextStyle(fontSize: 11, color: AmaqColors.slateText)),
            onChanged: (val) => setState(() => _wifiOnly = val),
          ),
          _tile(
            icon: Icons.speed,
            title: 'التحميلات المتزامنة القصوى',
            subtitle: '$_maxConcurrent ملفات في نفس الوقت',
            trailing: DropdownButton<int>(
              value: _maxConcurrent,
              dropdownColor: AmaqColors.midnightSurface,
              style: const TextStyle(color: AmaqColors.signalCyan, fontSize: 13),
              underline: const SizedBox(),
              items: [1, 2, 3, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _maxConcurrent = val);
              },
            ),
          ),
          const SizedBox(height: 20),

          // About Amaq Telecom
          _sectionTitle('عن التطبيق والهوية'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AmaqColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmaqColors.primaryNavy),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 70),
                const SizedBox(height: 12),
                const Text(
                  'AMAQDOWNLOADER',
                  style: TextStyle(fontWeight: FontWeight.black, fontSize: 16, color: Colors.white),
                ),
                const Text(
                  'الإصدار 1.0.0 (Clean Pro Edition)',
                  style: TextStyle(color: AmaqColors.signalCyan, fontSize: 12),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تطبيق مخصص لتنزيل وسائط الإنترنت الفورية بجودة فائقة وبدون أي برمجيات إعلانية أو تعقب، مقدم من أعماق للاتصالات.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AmaqColors.slateText, fontSize: 11, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(color: AmaqColors.signalCyan, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AmaqColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AmaqColors.signalCyan, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AmaqColors.slateText)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
