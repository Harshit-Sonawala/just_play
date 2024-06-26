import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audioplayer_provider.dart';
import '../screens/playback_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioPlayerProvider>(create: (context) => AudioPlayerProvider()),
      ],
      child: const JustPlay(),
    ),
  );
}

class JustPlay extends StatelessWidget {
  const JustPlay({super.key});
  @override
  Widget build(BuildContext context) {
    // Custom App-wide Colors:
    const Color appWideAccentColor = Color(0xff4bdbff);
    const Color appWideDarkBackgroundColor = Color(0xff1d1d1d);
    const Color appWideDarkMidColor = Color(0xff222222);
    const Color appWideDarkTopColor = Color(0xff333333);
    const Color appWideDarkDimForegroundColor = Color(0xff4d4d4d);
    const Color appWideDarkForegroundColor = Color(0xfff3f3f3);

    // Custom App-wide Text Theme:
    const TextTheme appWideTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: appWideAccentColor,
      ),
      displayMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: appWideAccentColor,
      ),
      displaySmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: appWideDarkForegroundColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.0,
        color: appWideDarkForegroundColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: appWideDarkForegroundColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14.0,
        color: appWideDarkForegroundColor,
      ),
    );

    return MaterialApp(
      title: 'Just Play',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      // Light Theme:
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: appWideDarkForegroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: appWideAccentColor,
        ),
        fontFamily: 'ProductSans',
        textTheme: appWideTextTheme,
        iconTheme: const IconThemeData(
          size: 24,
          color: appWideDarkBackgroundColor,
        ),
      ),

      // Dark Theme:
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        // Base Color Theme:
        scaffoldBackgroundColor: appWideDarkBackgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: appWideAccentColor,
          secondary: Colors.white,
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
            backgroundColor: appWideDarkTopColor,
            // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        // TextField Theme:
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: appWideAccentColor,
            ),
          ),
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          labelStyle: const TextStyle(
            color: appWideAccentColor,
          ),
          iconColor: Colors.white,
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
        ),
      ),
      home: const PlaybackScreen(),
    );
  }
}

// import 'package:flutter/material.dart';

// import './widgets/custom_gradient_background.dart';
// import './screens/bottom_nav_screen.dart';

// void main() {
//   runApp(
//     const Apollo(),
//   );
// }

// class Apollo extends StatelessWidget {
//   const Apollo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Apollo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         splashColor: const Color.fromRGBO(75, 219, 255, 0.342),
//         colorScheme: const ColorScheme(
//           brightness: Brightness.dark,
//           surface: Color.fromARGB(24, 255, 255, 255),
//           onSurface: Colors.white,
//           primary: Color(0xff4bdbff),
//           onPrimary: Color(0xff1d1d1d),
//           secondary: Color.fromARGB(255, 11, 190, 152),
//           onSecondary: Color(0xff2f88ee),
//           error: Color(0xffdd1b6c),
//           onError: Color(0xff1d1d1d),
//         ),
//         useMaterial3: true,
//         fontFamily: 'ProductSans',
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//             fontSize: 28.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xff4bdbff),
//           ),
//           displayMedium: TextStyle(
//             fontSize: 26.0,
//             fontWeight: FontWeight.bold,
//           ),
//           displaySmall: TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             color: Color(0xff4bdbff),
//           ),
//           bodyLarge: TextStyle(
//             fontSize: 24.0,
//           ),
//           bodyMedium: TextStyle(
//             fontSize: 19.0,
//           ),
//           bodySmall: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         buttonTheme: const ButtonThemeData(
//           padding: EdgeInsets.all(0),
//         ),
//         iconTheme: const IconThemeData(
//           size: 20,
//           color: Colors.white,
//         ),
//       ),
//       home: const CustomGradientBackground(
//         child: BottomNavScreen(),
//       ),
//     );
//   }
// }
