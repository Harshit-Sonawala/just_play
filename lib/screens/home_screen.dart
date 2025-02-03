import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_list_item.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Future<List<Track>>? trackListFuture;
  final Function(int) onSortModeChanged; // Callback function

  const HomeScreen({
    super.key,
    required this.trackListFuture,
    required this.onSortModeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchTextFieldController = TextEditingController();
  final FocusNode searchTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<Track>>(
          future: widget.trackListFuture,
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
              // Header
              // debugPrint('WrapperScreen snapshot.data: ${snapshot.data}');
              return Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surfaceDim,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
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
                                    textInputAction:
                                        TextInputAction.search, // replaces keyboard's Enter with Search Icon
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
                                          Icons.search_rounded,
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
                                  builder: (BuildContext context, MenuController menuAnchorController, Widget? child) {
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
                                      child: Text('Alphabetical Asc', style: Theme.of(context).textTheme.bodySmall),
                                      onPressed: () => setState(() {
                                        widget.onSortModeChanged(0);
                                      }),
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      child: Text('Alphabetical Desc', style: Theme.of(context).textTheme.bodySmall),
                                      onPressed: () => setState(() {
                                        widget.onSortModeChanged(1);
                                      }),
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      child: Text('Date Modified Asc', style: Theme.of(context).textTheme.bodySmall),
                                      onPressed: () => setState(() {
                                        widget.onSortModeChanged(2);
                                      }),
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      child: Text('Date Modified Desc', style: Theme.of(context).textTheme.bodySmall),
                                      onPressed: () => setState(() {
                                        widget.onSortModeChanged(3);
                                      }),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.settings_rounded),
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
                                  debugPrint('Play Quick Tracks pressed.');
                                },
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                borderRadius: 50,
                                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                icon: Icons.playlist_add_rounded,
                                iconSize: 22,
                                iconColor: Theme.of(context).colorScheme.secondary,
                                title: 'Play All',
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
                    ),
                  ),

                  // All Tracks ListView Builder
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
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CustomListItem(
                              onPressed: () {
                                Provider.of<AudioPlayerProvider>(context, listen: false).setAudioPlayerFile(eachTrack);
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
              debugPrint('WrapperScreen Error: ${snapshot.error}');
              return Center(
                child: Text('WrapperScreen Error: ${snapshot.error}'),
              );
            } else {
              // unexpected case but no error encountered
              debugPrint('WrapperScreen Unexpected: $snapshot');
              return Center(
                child: Text('WrapperScreen Unexpected: $snapshot'),
              );
            }
          },
        ),
        Positioned(
          bottom: 90,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
            onPressed: () {
              debugPrint('Shuffle Play pressed.');
            },
            child: Icon(
              Icons.shuffle_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // child: SizedBox(
          //   height: 60,
          //   width: 60,
          //   child: CustomElevatedButton(
          //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          //     borderRadius: 50,
          //     backgroundColor: Theme.of(context).colorScheme.surfaceBright,
          //     icon: Icons.shuffle_rounded,
          //     iconSize: 22,
          //     iconColor: Theme.of(context).colorScheme.secondary,
          //   ),
          // ),
        ),
      ],
    );
  }
}
