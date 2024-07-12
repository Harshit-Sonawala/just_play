import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Global dark theme:
  bool isDarkTheme = true;

  // Global accent color:
  Color globalAccentColor = const Color(0xFF4FACD6);

  // Global dark theme colors:
  Color globalDarkBackgroundColor = const Color(0xff1d1d1d);
  Color globalDarkMidColor = const Color(0xff222222);
  Color globalDarkTopColor = const Color(0xff2f2f2f);
  Color globalDarkDimForegroundColor = const Color(0xff4d4d4d);
  Color globalDarkForegroundColor = const Color(0xfff3f3f3);

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
