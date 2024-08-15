import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Global dark theme:
  bool isDarkTheme = true;

  // Global main colors:
  Color globalPrimaryColor = const Color(0xFF43D0F6);
  Color globalSecondaryColor = const Color(0xFF7E8BFF);
  Color globalTertiaryColor = const Color(0xFF9BE2F5);

  // Global dark theme foreground & background colors:
  Color globalDarkSurfaceColor = const Color(0xFF1A2324);
  Color globalDarkSurfaceBrightColor = const Color(0xFF242D2F);
  Color globalDarkSurfaceDimColor = const Color(0xFF0D1517);
  Color globalOnSurfaceColor = const Color(0xFFF3F3F3);
  Color globalOnSurfaceVariantColor = const Color(0xFFA5A5A5);

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
