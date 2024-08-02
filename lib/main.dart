import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/audioplayer_provider.dart';
import '../providers/theme_provider.dart';

import '../screens/onboarding_screen.dart';
import '../screens/playback_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioPlayerProvider>(
          create: (context) => AudioPlayerProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const JustPlay(),
    ),
  );
}

class JustPlay extends StatefulWidget {
  const JustPlay({super.key});

  @override
  State<JustPlay> createState() => _JustPlayState();
}

class _JustPlayState extends State<JustPlay> {
  bool? showOnboardingScreen;

  @override
  void initState() {
    super.initState();
    initializeWithSharedPrefs();
  }

  Future<void> initializeWithSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    showOnboardingScreen = prefs.getBool('showOnboardingScreen');
    debugPrint('main.dart showOnboardingScreen: $showOnboardingScreen');
  }

  @override
  Widget build(BuildContext context) {
    // Custom App-wide Text Theme:
    TextTheme appWideTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalAccentColor,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalAccentColor,
      ),
      displaySmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14.0,
        color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
      ),
    );

    return MaterialApp(
      title: 'Just Play',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      // Light Theme:
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Provider.of<ThemeProvider>(context).globalAccentColor,
        ),
        fontFamily: 'ProductSans',
        textTheme: appWideTextTheme,
        iconTheme: IconThemeData(
          size: 24,
          color: Provider.of<ThemeProvider>(context).globalDarkBackgroundColor,
        ),
      ),

      // Dark Theme:
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        // Base Color Theme:
        scaffoldBackgroundColor: Provider.of<ThemeProvider>(context).globalDarkBackgroundColor,
        splashColor: Provider.of<ThemeProvider>(context).globalAccentColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Provider.of<ThemeProvider>(context).globalAccentColor,
          secondary: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
          brightness: Brightness.dark,
        ),

        // Icon Theme:
        fontFamily: 'ProductSans',
        textTheme: appWideTextTheme,

        // Icon Theme:
        iconTheme: const IconThemeData(
          size: 24,
          color: Colors.white,
        ),

        // Button Theme:
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Provider.of<ThemeProvider>(context).globalDarkTopColor,
            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // TextField Theme:
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          labelStyle: TextStyle(
            color: Provider.of<ThemeProvider>(context).globalAccentColor,
          ),
          filled: true,
          isDense: true,
          fillColor: Provider.of<ThemeProvider>(context).globalDarkTopColor,
          iconColor: Colors.white,
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
            ),
          ),
        ),

        // Snackbar Theme:
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Provider.of<ThemeProvider>(context).globalDarkMidColor,
          actionBackgroundColor: Provider.of<ThemeProvider>(context).globalDarkTopColor,
          actionTextColor: Provider.of<ThemeProvider>(context).globalAccentColor,
        ),
      ),
      home: (showOnboardingScreen == null || showOnboardingScreen == true)
          ? const OnboardingScreen()
          : const OnboardingScreen(),
      // : const PlaybackScreen(),
    );
  }
}
