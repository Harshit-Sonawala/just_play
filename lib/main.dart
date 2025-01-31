import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/onboarding_screen.dart';
import '../screens/playback_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/database_provider.dart';
import '../providers/audio_player_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (context) => DatabaseProvider(),
        ),
        ChangeNotifierProvider<AudioPlayerProvider>(
          create: (context) => AudioPlayerProvider(),
        ),
        // ChangeNotifierProxyProvider<DatabaseProvider, AudioPlayerProvider>(
        //   create: (context) => AudioPlayerProvider(context.read<DatabaseProvider>()),
        //   update: (context, databaseProvider, audioPlayerProvider) => audioPlayerProvider!,
        // ),
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

  Future<void> initializeDatabaseGetSharedPrefs() async {
    await Provider.of<DatabaseProvider>(context, listen: false).initializeTrackDatabase();
    return Provider.of<AudioPlayerProvider>(context, listen: false).initializeSharedPrefs();
  }

  @override
  void dispose() {
    Provider.of<DatabaseProvider>(context, listen: false).closeTrackDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom App-wide Text Theme:
    TextTheme appWideTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalSecondaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalSecondaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Provider.of<ThemeProvider>(context).globalSecondaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
      ),
    );

    return MaterialApp(
      title: 'Just Play',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      // Light Theme:
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Provider.of<ThemeProvider>(context).globalPrimaryColor,
        ),
        fontFamily: 'ProductSans',
        textTheme: appWideTextTheme,
        iconTheme: IconThemeData(
          size: 26,
          color: Provider.of<ThemeProvider>(context).globalDarkSurfaceDimColor,
        ),
      ),

      // Dark Theme:
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        // Base Color Theme:
        scaffoldBackgroundColor: Provider.of<ThemeProvider>(context).globalDarkSurfaceDimColor,
        splashColor: Provider.of<ThemeProvider>(context).globalPrimaryColor,
        colorScheme: ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Provider.of<ThemeProvider>(context).globalPrimaryColor,
          // onPrimary: Provider.of<ThemeProvider>(context).globalOnPrimaryColor,
          secondary: Provider.of<ThemeProvider>(context).globalSecondaryColor,
          tertiary: Provider.of<ThemeProvider>(context).globalTertiaryColor,
          // onSecondary: Provider.of<ThemeProvider>(context).globalOnSecondaryColor,
          surface: Provider.of<ThemeProvider>(context).globalDarkSurfaceColor,
          surfaceBright: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
          surfaceDim: Provider.of<ThemeProvider>(context).globalDarkSurfaceDimColor,
          onSurface: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
          onSurfaceVariant: Provider.of<ThemeProvider>(context).globalOnSurfaceVariantColor,
        ),

        // Font Theme:
        fontFamily: 'ProductSans',
        textTheme: appWideTextTheme,

        // Icon Theme:
        iconTheme: IconThemeData(
          size: 24,
          color: Provider.of<ThemeProvider>(context).globalOnSurfaceColor,
        ),

        // Button Theme:
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // TextField Theme:
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          hintStyle: TextStyle(
            color: Provider.of<ThemeProvider>(context).globalOnSurfaceVariantColor,
            fontSize: 16,
            height: 0.5,
          ),
          labelStyle: TextStyle(
            color: Provider.of<ThemeProvider>(context).globalSecondaryColor,
            height: 0.5,
          ),
          filled: true,
          isDense: true,
          fillColor: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
          iconColor: Provider.of<ThemeProvider>(context).globalSecondaryColor,
          prefixIconColor: Provider.of<ThemeProvider>(context).globalSecondaryColor,
          suffixIconColor: Provider.of<ThemeProvider>(context).globalSecondaryColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
          // disabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(50),
          //   borderSide: BorderSide(
          //     color: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
          //   ),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(50),
          //   borderSide: BorderSide(
          //     color: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
          //   ),
          // ),
        ),

        // Snackbar Theme:
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Provider.of<ThemeProvider>(context).globalDarkSurfaceColor,
          actionBackgroundColor: Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor,
          actionTextColor: Provider.of<ThemeProvider>(context).globalPrimaryColor,
        ),

        // Menu Theme:
        menuTheme: MenuThemeData(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Provider.of<ThemeProvider>(context).globalDarkSurfaceBrightColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        // Slider Theme:
        sliderTheme: SliderThemeData(
          activeTrackColor: Provider.of<ThemeProvider>(context).globalTertiaryColor,
          inactiveTrackColor: Provider.of<ThemeProvider>(context).globalSecondaryColor,
          thumbColor: Provider.of<ThemeProvider>(context).globalPrimaryColor,
          // thumbShape: SliderComponentShape.noThumb,
        ),
      ),

      // home: (showOnboardingScreen == null) ? const OnboardingScreen() : const PlaybackScreen(),
      home: FutureBuilder<void>(
        future: initializeDatabaseGetSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Loading Media...', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // debugPrint('Main snapshot.data: ${snapshot.data}');
            showOnboardingScreen =
                Provider.of<AudioPlayerProvider>(context, listen: false).prefs?.getBool('showOnboardingScreen');
            // debugPrint('Main showOnboardingScreen: $showOnboardingScreen');
            if (showOnboardingScreen == null) {
              return const OnboardingScreen();
            } else {
              return const PlaybackScreen();
            }
          } else if (snapshot.hasError) {
            // unexpected case and encounterred error
            debugPrint('Main Error: ${snapshot.error}');
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text('Main Error: ${snapshot.error}'),
                ),
              ),
            );
          } else {
            // unexpected case but no error encountered
            debugPrint('Main Unexpected: $snapshot');
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text('Main Unexpected: $snapshot'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
