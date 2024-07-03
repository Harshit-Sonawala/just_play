import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audioplayer_provider.dart';

import '../widgets/custom_list_item.dart';
import '../widgets/custom_card.dart';

import '../screens/settings_screen.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  bool isPlaying = false;

  String formatDuration(Duration? duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration!.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (hours > 0) hours, minutes, seconds].map((seg) => seg.toString()).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'JustPlay!',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          debugPrint("Search Button Pressed");
                        },
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const SettingsScreen();
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  // itemExtent: 80.0,
                  itemCount: Provider.of<AudioPlayerProvider>(context).filesList.length,
                  itemBuilder: (context, index) {
                    final eachFile = Provider.of<AudioPlayerProvider>(context).filesList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: CustomListItem(
                        onPressed: () {
                          Provider.of<AudioPlayerProvider>(context, listen: false).setAudioPlayerFile(eachFile.path);
                        },
                        onLongPress: () {},
                        title: eachFile.path.split('/').last,
                        artist: '',
                        album: '',
                        // body: eachFile.path,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<AudioPlayerProvider>(context).currentFilePath == ""
                        ? 'Track Title'
                        : Provider.of<AudioPlayerProvider>(context).currentFilePath.split('/').last,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        formatDuration(Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Slider(
                          value:
                              Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition!.inSeconds.toDouble(),
                          min: 0,
                          max: Provider.of<AudioPlayerProvider>(context).currentFileDuration!.inSeconds.toDouble(),
                          onChanged: (newSeekValue) {
                            Provider.of<AudioPlayerProvider>(context, listen: false)
                                .audioPlayer
                                .seek(Duration(seconds: newSeekValue.toInt()));
                          },
                        ),
                      ),
                      Text(
                        formatDuration(Provider.of<AudioPlayerProvider>(context).currentFileDuration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.skip_previous_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              if (isPlaying) {
                                isPlaying = false;
                                Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                              } else {
                                isPlaying = true;
                                Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.skip_next_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
