import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3D7DF3),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3D7DF3),
      secondary: Color(0xFFF05454),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFBBBBBB)),
    ),
    useMaterial3: true,
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF3D7DF3),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F5F7)),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3D7DF3),
      secondary: Color(0xFFFF6B6B),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      bodyMedium: TextStyle(color: Color(0xFF666666)),
    ),
    useMaterial3: true,
  );
}
