import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nknu_connect/core/theme/app_theme.dart';
import 'package:nknu_connect/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(DevicePreview(enabled: kDebugMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKNU Connect',
      theme: AppTheme.light,
      home: HomePage(),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
