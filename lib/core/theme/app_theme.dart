import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFEC407A),
      // primary
      primary: Color(0xFF8D4A5A),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFD9DF),
      onPrimaryContainer: Color(0xFF3F0017),
      // secondary
      secondary: Color(0xFF75565C),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFD9DF),
      onSecondaryContainer: Color(0xFF3F0017),
      // tertiary
      tertiary: Color(0xFF7A5733),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFDCBD),
      onTertiaryContainer: Color(0xFF2C1600),
      // error
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      // others
      surface: Color(0xFFFFF8F7),
      onSurface: Color(0xFF22191B),
      surfaceContainerHighest: Color(0xFFEFDEED),
      onSurfaceVariant: Color(0xFF524346),
      outline: Color(0xFFB47375),
      shadow: Color(0xFF000000),
      inverseSurface: Color(0xFF382E30),
      onInverseSurface: Color(0xFFFEEDEE),
      inversePrimary: Color(0xFFFFB1C2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    ),
  );
}

// class AppTheme {
//   static ThemeData light = ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Color.fromARGB(255, 236, 64, 122),
//       primary: Color.fromARGB(255, 236, 64, 122),
//       primaryContainer: Color.fromARGB(255, 255, 216, 236),
//       secondary: Color.fromARGB(255, 244, 143, 177),
//       onSurface: Color.fromARGB(255, 31, 26, 28),
//       onPrimary: Color.fromARGB(255, 255, 255, 255),
//       onPrimaryContainer: Color.fromARGB(255, 62, 0, 29),
//       outline: Color.fromARGB(255, 130, 115, 119),
//       surface: Color.fromARGB(255, 231, 231, 231),
//       surfaceContainer: Color.fromARGB(255, 255, 255, 255),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       fillColor: Color.fromARGB(255, 255, 255, 255),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//     ),
//   );
// }
