import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

ThemeData light =
    FlexThemeData.light(scheme: FlexScheme.blue, useMaterial3: false);
// ThemeData light = ThemeData(
//   fontFamily: 'Vazirmatn',
//   primaryColor: const Color(0xFFA12559),
//   brightness: Brightness.light,
//   highlightColor: Colors.white,
//   hintColor: const Color(0xFF9E9E9E),
//   scaffoldBackgroundColor: Colors.white70,
//   colorScheme: const ColorScheme.light(
//     primary: Color(0xFF1455AC),
//     secondary: Color(0xFF004C8E),
//     tertiary: Color(0xFFF9D4A8),
//     tertiaryContainer: Color(0xFFADC9F3),
//     onTertiaryContainer: Color(0xFF33AF74),
//     primaryContainer: Color(0xFF9AECC6),
//     secondaryContainer: Color(0xFFF2F2F2),
//   ),
//   pageTransitionsTheme: const PageTransitionsTheme(builders: {
//     TargetPlatform.android: ZoomPageTransitionsBuilder(),
//     TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
//     TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
//   }),
// );
