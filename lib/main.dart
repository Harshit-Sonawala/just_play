// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

void main() {
  runApp(const JustPlay());
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: PlaybackScreen(),
    );
  }
}

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});
  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  final audioPlayer = AudioPlayer();
  String currentFilePath = '/storage/emulated/0/Music/01 Greyhound.mp3';
  Duration currentFileDuration = Duration.zero;
  bool fileExists = false;
  bool nowPlaying = false;

  final pathTextFieldController = TextEditingController(text: '/storage/emulated/0/Music/01 Greyhound.mp3');

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _setPlayerFile();
  }

  @override
  void dispose() {
    pathTextFieldController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    // final plugin = DeviceInfoPlugin();
    final android = await DeviceInfoPlugin().androidInfo;
    Permission selectedPermissionType;

    if (android.version.sdkInt < 33) {
      selectedPermissionType = Permission.storage;
    } else {
      selectedPermissionType = Permission.audio;
    }

    PermissionStatus permissionStatus = await selectedPermissionType.status;
    debugPrint('Initial permission status: $permissionStatus');

    if (permissionStatus.isDenied) {
      permissionStatus = await selectedPermissionType.request();
      debugPrint('After requested permission status: $permissionStatus');
    }

    if (permissionStatus.isGranted) {
      if (File(currentFilePath).existsSync()) {
        setState(() {
          fileExists = true;
        });
      } else {
        debugPrint("File doesn't exist.");
      }
    } else {
      // Handle permission denial
      debugPrint("Permission Denied.");
      // openAppSettings();
    }
  }

  Future<void> _setPlayerFile() async {
    final currentFileDuration = await audioPlayer.setFilePath(currentFilePath);
  }

  Future<void> _togglePlayerPlayPause() async {
    if (!nowPlaying) {
      debugPrint("Playing...");
      if (fileExists) {
        await audioPlayer.play();
      } else {
        debugPrint("File not found.");
        // Toast/Snackbar
      }
    } else {
      await audioPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('JustPlay!'),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => {
                        debugPrint("Settings Button Pressed"),
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text('$currentFilePath'),
                SizedBox(height: 10),
                Text('Artist'),
                SizedBox(height: 20),
                LinearProgressIndicator(),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    nowPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 36,
                  ),
                  onPressed: () => {
                    _togglePlayerPlayPause(),
                    setState(() {
                      nowPlaying = !nowPlaying;
                    }),
                  },
                ),
                SizedBox(height: 40),
                Text('Up Next'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Path:'),
                    Expanded(
                      child: TextField(
                        controller: pathTextFieldController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Select File'),
                  onPressed: () => {
                    setState(() {
                      currentFilePath = pathTextFieldController.text;
                      _setPlayerFile();
                    }),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
