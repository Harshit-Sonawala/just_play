import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Global dark theme:
  bool isDarkTheme = true;

  // Global accent color:
  Color globalAccentColor = Color(0xff4bdbff);

  // Global dark theme colors:
  Color globalDarkBackgroundColor = Color(0xff1d1d1d);
  Color globalDarkMidColor = Color(0xff222222);
  Color globalDarkTopColor = Color(0xff333333);
  Color globalDarkDimForegroundColor = Color(0xff4d4d4d);
  Color globalDarkForegroundColor = Color(0xfff3f3f3);

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
