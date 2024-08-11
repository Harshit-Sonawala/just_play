import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_list_item.dart';
import '../widgets/custom_card.dart';
import '../screens/settings_screen.dart';
import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';
import '../providers/theme_provider.dart';

import '../objectbox.g.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  bool isPlaying = false;
  Future<List<Track>>? trackListFuture;
  int sortByInt = 3; // read from sharedprefs

  @override
  void initState() {
    super.initState();
    // no await as this is just a Future we are passing to the FutureBuilder, and not a value
    readTracksFromDatabase();
  }

  void readTracksFromDatabase() {
    if (sortByInt == 1) {
      // Alphabetical Desc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileName, descending: true);
    } else if (sortByInt == 2) {
      // DateModified Asc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileLastModified);
    } else if (sortByInt == 3) {
      // DateModified Desc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileLastModified, descending: true);
    } else {
      // Alphabetical Asc & Default
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false).readAllTracks();
    }
  }

  // Convert fileDuration in seconds to formatted string of type 00:00
  String formatDurationIntToString(int fileDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = fileDuration ~/ 3600;
    final minutes = (fileDuration % 3600) ~/ 60;
    final seconds = fileDuration % 60;

    return [if (hours > 0) hours, minutes, seconds].map((seg) => twoDigits(seg)).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<Track>>(
              future: trackListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Loading Media...', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  // debugPrint('PlaybackScreen snapshot.data: ${snapshot.data}');
                  return Column(
                    children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  // PopupMenuButton(
                                  //   itemBuilder: (context) => [
                                  //     PopupMenuItem(child: Text('Date Modified Asc', style: Theme.of(context).textTheme.bodySmall), value: 0),
                                  //     PopupMenuItem(child: Text('Date Modified Desc', style: Theme.of(context).textTheme.bodySmall), value: 1),
                                  //     PopupMenuItem(child: Text('Alphabetical Asc', style: Theme.of(context).textTheme.bodySmall), value: 2),
                                  //     PopupMenuItem(child: Text('Alphabetical Desc', style: Theme.of(context).textTheme.bodySmall), value: 3),
                                  //   ],
                                  // ),
                                  MenuAnchor(
                                    builder:
                                        (BuildContext context, MenuController menuAnchorController, Widget? child) {
                                      return IconButton(
                                        onPressed: () {
                                          if (menuAnchorController.isOpen) {
                                            menuAnchorController.close();
                                          } else {
                                            menuAnchorController.open();
                                          }
                                        },
                                        icon: const Icon(Icons.sort_rounded),
                                      );
                                    },
                                    menuChildren: [
                                      MenuItemButton(
                                        leadingIcon: Icon(
                                          Icons.keyboard_double_arrow_up_rounded,
                                          color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                                        ),
                                        child: Text('Alphabetical Asc', style: Theme.of(context).textTheme.bodySmall),
                                        onPressed: () => setState(() {
                                          sortByInt = 0;
                                          Provider.of<AudioPlayerProvider>(context).prefs?.setInt('sortByInt', 0);
                                          readTracksFromDatabase();
                                        }),
                                      ),
                                      MenuItemButton(
                                        leadingIcon: Icon(
                                          Icons.keyboard_double_arrow_down_rounded,
                                          color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                                        ),
                                        child: Text('Alphabetical Desc', style: Theme.of(context).textTheme.bodySmall),
                                        onPressed: () => setState(() {
                                          sortByInt = 1;
                                          Provider.of<AudioPlayerProvider>(context).prefs?.setInt('sortByInt', 1);
                                          readTracksFromDatabase();
                                        }),
                                      ),
                                      MenuItemButton(
                                        leadingIcon: Icon(
                                          Icons.keyboard_double_arrow_up_rounded,
                                          color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                                        ),
                                        child: Text('Date Modified Asc', style: Theme.of(context).textTheme.bodySmall),
                                        onPressed: () => setState(() {
                                          sortByInt = 2;
                                          Provider.of<AudioPlayerProvider>(context).prefs?.setInt('sortByInt', 2);
                                          readTracksFromDatabase();
                                        }),
                                      ),
                                      MenuItemButton(
                                        leadingIcon: Icon(
                                          Icons.keyboard_double_arrow_down_rounded,
                                          color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                                        ),
                                        child: Text('Date Modified Desc', style: Theme.of(context).textTheme.bodySmall),
                                        onPressed: () => setState(() {
                                          sortByInt = 3;
                                          Provider.of<AudioPlayerProvider>(context).prefs?.setInt('sortByInt', 3);
                                          readTracksFromDatabase();
                                        }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const SettingsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            // itemExtent: 80,
                            // itemCount: Provider.of<AudioPlayerProvider>(context).trackList.length,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              // final eachTrack = Provider.of<AudioPlayerProvider>(context).trackList[index];
                              Track eachTrack = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: CustomListItem(
                                  onPressed: () {
                                    Provider.of<AudioPlayerProvider>(context, listen: false)
                                        .setAudioPlayerFile(eachTrack.filePath);
                                  },
                                  onLongPress: () {
                                    // Play next / some playlist functionality
                                  },
                                  fileName: eachTrack.fileName,
                                  title: eachTrack.title,
                                  artist: eachTrack.artist,
                                  album: eachTrack.album,
                                  albumArt: eachTrack.albumArt,
                                  duration: eachTrack.fileDuration,
                                  // body: eachTrack.path,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else if (snapshot.hasError) {
                  // unexpected case and encounterred error\
                  debugPrint('PlaybackScreen Error: ${snapshot.error}');
                  return Center(
                    child: Text('PlaybackScreen Error: ${snapshot.error}'),
                  );
                } else {
                  // unexpected case but no error encountered
                  debugPrint('PlaybackScreen Unexpected: $snapshot');
                  return Center(
                    child: Text('PlaybackScreen Unexpected: $snapshot'),
                  );
                }
              },
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.25, // Initial height of the bottom bar
              minChildSize: 0.25, // Minimum height of the bottom bar
              maxChildSize: 1.0, // Maximum height (full screen)
              builder: (context, nowPlayingScrollController) {
                return CustomCard(
                  child: SingleChildScrollView(
                    controller: nowPlayingScrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Decoration Handle Rectangle Container
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 40.0,
                            height: 5.0,
                            decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context).globalDarkDimForegroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Provider.of<AudioPlayerProvider>(context).currentFilePath == ""
                              ? 'Select a file and JustPlay!'
                              : Provider.of<AudioPlayerProvider>(context).currentFilePath.split('/').last,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              formatDurationIntToString(
                                  Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Expanded(
                              child: Slider(
                                value: Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition.toDouble(),
                                min: 0,
                                max: Provider.of<AudioPlayerProvider>(context).currentFileDuration.toDouble(),
                                onChanged: (newSeekValue) {
                                  Provider.of<AudioPlayerProvider>(context, listen: false)
                                      .audioPlayer
                                      .seek(Duration(seconds: newSeekValue.toInt()));
                                },
                              ),
                            ),
                            Text(
                              formatDurationIntToString(Provider.of<AudioPlayerProvider>(context).currentFileDuration),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.skip_previous_rounded,
                                  size: 36,
                                ),
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 36,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (Provider.of<AudioPlayerProvider>(context, listen: false).currentFilePath != '') {
                                    if (isPlaying) {
                                      isPlaying = false;
                                      Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                                    } else {
                                      isPlaying = true;
                                      Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.skip_next_rounded,
                                  size: 36,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Expanded full-screen content
                        Container(
                          height: 500, // Customize as per your need
                          color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
                          child: const Center(
                            child: Text("Full-Screen Context"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                     boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
//                   ),
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     child: Column(
//                       children: [
//                         // Handle for dragging
//                         Container(
//                           width: 40,
//                           height: 5,
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),

//                         // Collapsed bottom bar content
//                         ListTile(
//                           leading: Icon(Icons.music_note),
//                           title: Text("Song Title"),
//                           subtitle: Text("Artist Name"),
//                           trailing: IconButton(
//                             icon: Icon(Icons.play_arrow),
//                             onPressed: () {},
//                           ),
//                         ),

//                         
//                         ),
//                       ],
//                     ),
//                   ),
//                 );