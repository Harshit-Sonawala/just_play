import 'package:flutter/material.dart';
import 'package:just_play/widgets/custom_divider.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_list_item.dart';
import '../widgets/now_playing_menu.dart';
import '../screens/settings_screen.dart';
// import '../screens/search_screen.dart';
import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';

import '../objectbox.g.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  Future<List<Track>>? trackListFuture;
  int? sortByInt;
  final searchTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readTracksFromDatabase();
  }

  void readTracksFromDatabase() {
    sortByInt = Provider.of<AudioPlayerProvider>(context, listen: false).prefs!.getInt('sortByInt') ?? 3;
    if (sortByInt == 1) {
      // Alphabetical Desc
      // no 'await' keyword as its a future we are passing to the FutureBuilder
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            // itemExtent: 80,
                            // itemCount: Provider.of<AudioPlayerProvider>(context).trackList.length,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // render Appbar
                                return Container(
                                  color: Theme.of(context).colorScheme.surfaceDim,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Header TextField
                                            Expanded(
                                              child: TextField(
                                                controller: searchTextFieldController,
                                                cursorColor: Theme.of(context).colorScheme.secondary,
                                                style: Theme.of(context).textTheme.displayMedium,
                                                decoration: InputDecoration(
                                                  hintText: 'JustPlay!',
                                                  hintStyle: Theme.of(context).textTheme.displayLarge,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                                  suffixIcon: IconButton(
                                                    style: IconButton.styleFrom(
                                                      padding: const EdgeInsets.all(0),
                                                      minimumSize: const Size(0, 0),
                                                    ),
                                                    icon: Icon(
                                                      Icons.search,
                                                      size: 24,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MenuAnchor(
                                                  builder: (BuildContext context, MenuController menuAnchorController,
                                                      Widget? child) {
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
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 20,
                                                        top: 10,
                                                        right: 20,
                                                      ),
                                                      child: Text(
                                                        'Sort By:',
                                                        style: Theme.of(context).textTheme.titleSmall,
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      child: CustomDivider(),
                                                    ),
                                                    MenuItemButton(
                                                      leadingIcon: Icon(
                                                        Icons.keyboard_arrow_up_rounded,
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                      child: Text('Alphabetical Asc',
                                                          style: Theme.of(context).textTheme.bodySmall),
                                                      onPressed: () => setState(() {
                                                        sortByInt = 0;
                                                        Provider.of<AudioPlayerProvider>(context, listen: false)
                                                            .prefs
                                                            ?.setInt('sortByInt', 0);
                                                        readTracksFromDatabase();
                                                      }),
                                                    ),
                                                    MenuItemButton(
                                                      leadingIcon: Icon(
                                                        Icons.keyboard_arrow_down_rounded,
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                      child: Text('Alphabetical Desc',
                                                          style: Theme.of(context).textTheme.bodySmall),
                                                      onPressed: () => setState(() {
                                                        sortByInt = 1;
                                                        Provider.of<AudioPlayerProvider>(context, listen: false)
                                                            .prefs
                                                            ?.setInt('sortByInt', 1);
                                                        readTracksFromDatabase();
                                                      }),
                                                    ),
                                                    MenuItemButton(
                                                      leadingIcon: Icon(
                                                        Icons.keyboard_arrow_up_rounded,
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                      child: Text('Date Modified Asc',
                                                          style: Theme.of(context).textTheme.bodySmall),
                                                      onPressed: () => setState(() {
                                                        sortByInt = 2;
                                                        Provider.of<AudioPlayerProvider>(context, listen: false)
                                                            .prefs
                                                            ?.setInt('sortByInt', 2);
                                                        readTracksFromDatabase();
                                                      }),
                                                    ),
                                                    MenuItemButton(
                                                      leadingIcon: Icon(
                                                        Icons.keyboard_arrow_down_rounded,
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                      child: Text('Date Modified Desc',
                                                          style: Theme.of(context).textTheme.bodySmall),
                                                      onPressed: () => setState(() {
                                                        sortByInt = 3;
                                                        Provider.of<AudioPlayerProvider>(context, listen: false)
                                                            .prefs
                                                            ?.setInt('sortByInt', 3);
                                                        readTracksFromDatabase();
                                                      }),
                                                    ),
                                                  ],
                                                ),
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
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // final eachTrack = Provider.of<AudioPlayerProvider>(context).trackList[index];
                              Track eachTrack = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: CustomListItem(
                                  onPressed: () {
                                    Provider.of<AudioPlayerProvider>(context, listen: false)
                                        .setAudioPlayerFile(eachTrack);
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
            const NowPlayingMenu(),
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