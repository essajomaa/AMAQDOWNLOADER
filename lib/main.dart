import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AmaqColors.midnightDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AmaqDownloaderApp());
}

class AmaqDownloaderApp extends StatelessWidget {
  const AmaqDownloaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMAQDOWNLOADER',
      debugShowCheckedModeBanner: false,
      theme: AmaqTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: const Locale('ar', 'AE'),
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainNavigationScreen(),
    );
  }
}
