import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../objectbox.g.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';

import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_list_item.dart';
import '../widgets/now_playing_menu.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  Future<List<Track>>? trackListFuture;
  int? sortByInt;
  final TextEditingController searchTextFieldController = TextEditingController();
  final FocusNode searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    readTracksFromDatabase();
  }

  void readTracksFromDatabase() {
    // Read the Previously Set Sort Option from Prefs
    sortByInt = Provider.of<AudioPlayerProvider>(context, listen: false).prefs!.getInt('sortByInt') ?? 3;

    // Sort the read track by
    // 0/Default - Alpha Asc
    // 1 - Alpha Desc
    // 2 - Date Asc
    // 3 - Date Desc
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
                  // Loading Tracks
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Loading Tracks...', style: Theme.of(context).textTheme.bodyLarge),
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
                              // render AppBar Header Row 1
                              if (index == 0) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Header Search TextField
                                        Expanded(
                                          child: Hero(
                                            tag: 'search_hero',
                                            child: Material(
                                              color: Colors.transparent,
                                              child: TextField(
                                                controller: searchTextFieldController,
                                                focusNode: searchTextFieldFocusNode,
                                                textInputAction: TextInputAction
                                                    .search, // replaces keyboard's Enter with Search Icon
                                                onSubmitted: (value) {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => SearchScreen(
                                                      searchTextFieldController: searchTextFieldController,
                                                      searchTextFieldFocusNode: searchTextFieldFocusNode,
                                                    ),
                                                  ));
                                                },
                                                onTapOutside: (event) => {
                                                  debugPrint('Unfocusing Header TextField.'),
                                                  // FocusManager.instance.primaryFocus?.unfocus(),
                                                  searchTextFieldFocusNode.unfocus(),
                                                },
                                                cursorColor: Theme.of(context).colorScheme.secondary,
                                                style: Theme.of(context).textTheme.displayMedium,
                                                decoration: InputDecoration(
                                                  hintText: 'JustPlay!',
                                                  hintStyle: Theme.of(context).textTheme.displayLarge,
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.search,
                                                      size: 24,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                    ),
                                                    onPressed: () => {
                                                      if (searchTextFieldController.text.isNotEmpty)
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => SearchScreen(
                                                            // Passing the TextEditingController and FocusNode for Hero
                                                            searchTextFieldController: searchTextFieldController,
                                                            searchTextFieldFocusNode: searchTextFieldFocusNode,
                                                          ),
                                                        ))
                                                      else
                                                        debugPrint('Search Query Empty'),
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),

                                        // Sort Menu Anchor and Settings
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
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => const SettingsScreen(),
                                                ));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 6),

                                    // AppBar Header Row 2
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Quick Tracks',
                                          ),
                                          CustomElevatedButton(
                                            onPressed: () {
                                              debugPrint('Shuffle Play pressed.');
                                            },
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                            borderRadius: 50,
                                            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                            icon: Icons.shuffle_rounded,
                                            iconSize: 22,
                                            iconColor: Theme.of(context).colorScheme.secondary,
                                            title: 'Shuffle Play',
                                            titleStyle: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Playlists'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('All Tracks'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                );
                              }

                              // Main Track List Builder
                              // final eachTrack = Provider.of<AudioPlayerProvider>(context).trackList[index];
                              Track eachTrack = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
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
                    ],
                  );
                } else if (snapshot.hasError) {
                  // unexpected case and error encounterred
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