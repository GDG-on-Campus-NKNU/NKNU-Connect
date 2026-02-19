import 'package:flutter/material.dart';
import 'package:nknu_connect/core/theme/app_theme.dart';
import 'package:nknu_connect/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKNU Connect',
      theme: AppTheme.light,
      home: HomePage(),
    );
  }
}
