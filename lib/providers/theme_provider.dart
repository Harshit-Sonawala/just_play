import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Global dark theme:
  bool isDarkTheme = true;

  // Global accent color:
  Color globalAccentColor = const Color(0xff4facd6);

  // Global dark theme colors:
  Color globalDarkBackgroundColor = const Color(0xff1d1d1d);
  Color globalDarkMidColor = const Color(0xff222222);
  Color globalDarkTopColor = const Color(0xff2f2f2f);
  Color globalDarkDimForegroundColor = const Color(0xffa5a5a5);
  Color globalDarkForegroundColor = const Color(0xfff3f3f3);
  Color globalDarkImageBackgroundColor = Color(0xFFBAD4E2);

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
