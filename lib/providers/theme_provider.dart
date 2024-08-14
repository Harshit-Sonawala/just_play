import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Global dark theme:
  bool isDarkTheme = true;

  // Global accent color:
  Color globalPrimaryColor = const Color(0xff4facd6);
  // Color globalOnPrimaryColor = const Color(0xff2e3e46);
  Color globalSecondaryColor = const Color(0xFF98BFD3);
  // Color globalOnSecondaryColor = const Color(0xff2e3e46);

  // Global dark theme colors:
  Color globalDarkSurfaceColor = const Color(0xff222222);
  Color globalDarkSurfaceBrightColor = const Color(0xff2f2f2f);
  Color globalDarkSurfaceDimColor = const Color(0xff1d1d1d);
  Color globalOnSurfaceColor = const Color(0xfff3f3f3);
  Color globalOnSurfaceVariantColor = const Color(0xffa5a5a5);
  // Color globalDarkImageBackgroundColor = const Color(0xFFBAD4E2);

  // ButtonStyle altButtonStyle = ElevatedButton.styleFrom(
  //   backgroundColor: const Color(0xff4facd6),
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(10),
  //   ),
  // );

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
