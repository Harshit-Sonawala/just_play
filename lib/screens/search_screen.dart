import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../main.dart';

import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_list_item.dart';
import '../widgets/now_playing_menu.dart';

class SearchScreen extends StatefulWidget {
  // // Catching the TextEditingController and FocusNode
  // final TextEditingController searchTextFieldController;
  // final FocusNode searchTextFieldFocusNode;

  const SearchScreen({
    super.key,
    // required this.searchTextFieldController,
    // required this.searchTextFieldFocusNode,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Track>>? searchResultTrackListFuture;
  final TextEditingController searchTextFieldController = TextEditingController();
  final FocusNode searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (searchTextFieldController.text.isNotEmpty) {
      searchTracksFromDatabase();
    }
  }

  void searchTracksFromDatabase() {
    setState(() {
      // searchResultTrackListFuture = Provider.of<DatabaseProvider>(context, listen: false).searchTracks(searchTextFieldController.text);
      searchResultTrackListFuture = trackStoreDatabase.searchTracks(searchTextFieldController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => {
                          Navigator.of(context).pop(),
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Search Results',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Search TextField
                  Hero(
                    tag: 'searchHero',
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: searchTextFieldController,
                        focusNode: searchTextFieldFocusNode,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => {
                          debugPrint('Tried Search with ${searchTextFieldController.text}'),
                          if (searchTextFieldController.text.isNotEmpty)
                            searchTracksFromDatabase()
                          else
                            debugPrint('Search Term Empty'),
                        },
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Enter search term...',
                          hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search_rounded,
                              size: 24,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () => {
                              debugPrint('Tried Search with ${searchTextFieldController.text}'),
                              if (searchTextFieldController.text.isNotEmpty)
                                searchTracksFromDatabase()
                              else
                                debugPrint('Search Term Empty'),
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search Results ListViewBuilder
                  FutureBuilder<List<Track>>(
                    future: searchResultTrackListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading Search Results
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Loading Results...', style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 20),
                              const CircularProgressIndicator(),
                            ],
                          ),
                        );
                      } else if (!(snapshot.hasData)) {
                        return Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.find_in_page_rounded,
                                    size: 64.0,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Search for File, Title, Artist or Album',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        // debugPrint('SearchScreen snapshot.data: ${snapshot.data}');
                        if (snapshot.data!.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 64.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Found no results. Please try again',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Found ${snapshot.data!.length} Results:',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      CustomElevatedButton(
                                        onPressed: () {
                                          audioPlayerProviderListenFalse.addAllToPlaylist(snapshot.data!);
                                          debugPrint('Playing All Search Results');
                                        },
                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                        borderRadius: 50,
                                        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                        icon: Icons.playlist_add_rounded,
                                        iconSize: 22,
                                        iconColor: Theme.of(context).colorScheme.secondary,
                                        title: 'Add All',
                                        titleStyle: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Search Results ListView Builder
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Track eachTrack = snapshot.data![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: CustomListItem(
                                          onPressed: () {
                                            // audioPlayerProviderListenFalse.setAudioPlayerFile(eachTrack);
                                            audioPlayerProviderListenFalse.addToPlaylist(eachTrack);
                                          },
                                          onLongPress: () {
                                            audioPlayerProviderListenFalse.addToPlaylistUpNext(eachTrack);
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
                              ],
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        // unexpected case and error encounterred
                        debugPrint('SearchScreen Error: ${snapshot.error}');
                        return Center(
                          child: Text('SearchScreen Error: ${snapshot.error}'),
                        );
                      } else {
                        // unexpected case but no error encountered
                        debugPrint('SearchScreen Unexpected: $snapshot');
                        return Center(
                          child: Text('SearchScreen Unexpected: $snapshot'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Floating Action Button Play All Search Results
            // Todo: Render in snapshot cases only?
            // Positioned(
            //   bottom: Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null ? 20 : 90,
            //   right: 10,
            //   child: FloatingActionButton(
            //     elevation: 0,
            //     backgroundColor: Theme.of(context).colorScheme.surfaceBright,
            //     onPressed: () {
            //       debugPrint('Play All Search Results pressed.');
            //     },
            //     child: Icon(
            //       Icons.playlist_add_rounded,
            //       size: 28,
            //       color: Theme.of(context).colorScheme.secondary,
            //     ),
            //   ),
            // ),

            const NowPlayingMenu(),
          ],
        ),
      ),
    );
  }
}
