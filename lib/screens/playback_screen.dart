// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audioplayer_provider.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  final pathTextFieldController = TextEditingController(text: '/storage/emulated/0/Music/03 Majula.mp3');
  bool isPlaying = false;

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
                      onPressed: () {
                        debugPrint("Settings Button Pressed");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(Provider.of<AudioPlayerProvider>(context).currentFilePath),
                SizedBox(height: 10),
                Text('Artist'),
                SizedBox(height: 20),
                LinearProgressIndicator(),
                SizedBox(height: 20),
                isPlaying
                    ? IconButton(
                        icon: Icon(
                          Icons.pause_rounded,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                            isPlaying = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                            isPlaying = true;
                          });
                        },
                      ),
                SizedBox(height: 40),
                Text('isPlaying: $isPlaying'),
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
                  onPressed: () {
                    Provider.of<AudioPlayerProvider>(context, listen: false)
                        .setAudioPlayerFile(pathTextFieldController.text);
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



// class PlaybackScreen extends StatefulWidget {
//   const PlaybackScreen({super.key});
//   @override
//   State<PlaybackScreen> createState() => _PlaybackScreenState();
// }

// class _PlaybackScreenState extends State<PlaybackScreen> {
//   final audioPlayer = AudioPlayer();
//   String currentFilePath = '/storage/emulated/0/Music/01 Greyhound.mp3';
//   Duration currentFileDuration = Duration.zero;
//   bool fileExists = false;
//   bool isPlaying = false;

//   final pathTextFieldController = TextEditingController(text: '/storage/emulated/0/Music/01 Greyhound.mp3');

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//     _setPlayerFile();
//   }

//   @override
//   void dispose() {
//     pathTextFieldController.dispose();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _requestPermission() async {
//     final android = await DeviceInfoPlugin().androidInfo;
//     Permission selectedPermissionType;

//     if (android.version.sdkInt < 33) {
//       selectedPermissionType = Permission.storage;
//     } else {
//       selectedPermissionType = Permission.audio;
//     }

//     PermissionStatus permissionStatus = await selectedPermissionType.status;
//     debugPrint('Initial permission status: $permissionStatus');

//     if (permissionStatus.isDenied) {
//       permissionStatus = await selectedPermissionType.request();
//       debugPrint('After requested permission status: $permissionStatus');
//     }

//     if (permissionStatus.isGranted) {
//       if (File(currentFilePath).existsSync()) {
//         setState(() {
//           fileExists = true;
//         });
//       } else {
//         debugPrint("File doesn't exist.");
//       }
//     } else {
//       // Handle permission denial
//       debugPrint("Permission Denied.");
//       // openAppSettings();
//     }
//   }

//   Future<void> _setPlayerFile() async {
//     await audioPlayer.setFilePath(currentFilePath);
//   }

//   Future<void> _togglePlayerPlayPause() async {
//     if (!isPlaying) {
//       debugPrint("Playing...");
//       if (fileExists) {
//         await audioPlayer.play();
//       } else {
//         debugPrint("File not found.");
//         // Toast/Snackbar
//       }
//     } else {
//       await audioPlayer.pause();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('JustPlay!'),
//                     IconButton(
//                       icon: Icon(Icons.settings),
//                       onPressed: () => {
//                         debugPrint("Settings Button Pressed"),
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 40),
//                 Text(currentFilePath),
//                 SizedBox(height: 10),
//                 Text('Artist'),
//                 SizedBox(height: 20),
//                 LinearProgressIndicator(),
//                 SizedBox(height: 20),
//                 IconButton(
//                   icon: Icon(
//                     isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                     size: 36,
//                   ),
//                   onPressed: () => {
//                     _togglePlayerPlayPause(),
//                     setState(() {
//                       isPlaying = !isPlaying;
//                     }),
//                   },
//                 ),
//                 SizedBox(height: 40),
//                 Text('Up Next'),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Path:'),
//                     Expanded(
//                       child: TextField(
//                         controller: pathTextFieldController,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   child: Text('Select File'),
//                   onPressed: () => {
//                     setState(() {
//                       currentFilePath = pathTextFieldController.text;
//                       _setPlayerFile();
//                     }),
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
