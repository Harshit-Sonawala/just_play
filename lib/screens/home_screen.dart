import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

// import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_list_item.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final Future<List<Track>>? trackListFuture;
  final Function(int) onSortModeChanged; // Callback function

  const HomeScreen({
    required this.trackListFuture,
    required this.onSortModeChanged,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            pinned: false,
            snap: false,
            stretch: false,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            // toolbarHeight: 50,
            // titleSpacing: 0,
            expandedHeight: 106,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  // AppBar Header Row 1
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Search TextField
                      Expanded(
                        child: Hero(
                          tag: 'searchHero',
                          child: Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SearchScreen(
                                      // searchTextFieldController: searchTextFieldController,
                                      // searchTextFieldFocusNode: searchTextFieldFocusNode,
                                      ),
                                )),
                              },
                              child: TextField(
                                enabled: false,
                                // controller: searchTextFieldController,
                                // focusNode: searchTextFieldFocusNode,
                                // textInputAction: TextInputAction.search, // replaces keyboard's Enter with Search Icon
                                // onSubmitted: (value) {
                                //   debugPrint(
                                //       'onSubmitted Trying to nav to search screen with ${searchTextFieldController.text}');
                                //   Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => SearchScreen(
                                //       searchTextFieldController: searchTextFieldController,
                                //       searchTextFieldFocusNode: searchTextFieldFocusNode,
                                //     ),
                                //   ));
                                // },
                                // onTapOutside: (event) => {
                                //   debugPrint('Unfocusing Header TextField.'),
                                //   // FocusManager.instance.primaryFocus?.unfocus(),
                                //   searchTextFieldFocusNode.unfocus(),
                                // },
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
                                    onPressed: null,
                                    // onPressed: () => {
                                    //   if (searchTextFieldController.text.isNotEmpty)
                                    //     {
                                    //       debugPrint(
                                    //           'onPressed Trying to nav to search screen with ${searchTextFieldController.text}'),
                                    //       Navigator.of(context).push(MaterialPageRoute(
                                    //         builder: (context) => SearchScreen(
                                    //           // Passing the TextEditingController and FocusNode for Hero
                                    //           searchTextFieldController: searchTextFieldController,
                                    //           searchTextFieldFocusNode: searchTextFieldFocusNode,
                                    //         ),
                                    //       ))
                                    //     }
                                    //   else
                                    //     {
                                    //       debugPrint('Search Query Empty'),
                                    //     }
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                  // const SizedBox(height: 4),
                  // AppBar Header Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            debugPrint('Play All pressed.');
                          },
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          borderRadius: 50,
                          backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                          icon: Icons.playlist_add_rounded,
                          iconSize: 22,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          title: 'Play All',
                          titleStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            debugPrint('New Tracks pressed.');
                          },
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          borderRadius: 50,
                          backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                          icon: Icons.new_releases_rounded,
                          iconSize: 22,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          title: 'New',
                          titleStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            debugPrint('Shuffle All pressed.');
                          },
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          borderRadius: 50,
                          backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                          icon: Icons.compare_arrows_rounded,
                          iconSize: 22,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          title: 'Shuffle All',
                          titleStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(52),
            //   child:
            // ),
          ),

          // Body FutureBuilder
          FutureBuilder<List<Track>>(
            future: widget.trackListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Loading Tracks
                return SliverToBoxAdapter(
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
                // debugPrint('WrapperScreen snapshot.data: ${snapshot.data}');
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: snapshot.data!.length,
                    (context, index) {
                      // final eachTrack = Provider.of<AudioPlayerProvider>(context).trackList[index];
                      Track eachTrack = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: CustomListItem(
                          onPressed: () {
                            // audioPlayerProviderListenFalse.setAudioPlayerFile(eachTrack);
                            audioPlayerProviderListenFalse.addToNowPlayingList(eachTrack);
                          },
                          onLongPress: () {
                            audioPlayerProviderListenFalse.addToNowPlayingListUpNext(eachTrack);
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
                );
              } else if (snapshot.hasError) {
                // unexpected case and error encounterred
                debugPrint('HomeScreen Error: ${snapshot.error}');
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('HomeScreen Error: ${snapshot.error}'),
                  ),
                );
              } else {
                // unexpected case but no error encountered
                debugPrint('HomeScreen Unexpected: $snapshot');
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('HomeScreen Unexpected: $snapshot'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
