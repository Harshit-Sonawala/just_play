// ignore_for_file: prefer_const_constructors
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
    return MaterialApp(
      title: 'Just Play',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ProductSans',
        primaryColor: Colors.blue,
      ),
      home: PlaybackScreen(),
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
