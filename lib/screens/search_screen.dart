import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';

import '../widgets/custom_list_item.dart';

class SearchScreen extends StatefulWidget {
  // Catching the TextEditingController and FocusNode
  final TextEditingController searchTextFieldController;
  final FocusNode searchTextFieldFocusNode;

  const SearchScreen({
    super.key,
    required this.searchTextFieldController,
    required this.searchTextFieldFocusNode,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Track>>? searchResultTrackListFuture;

  @override
  void initState() {
    super.initState();
    if (widget.searchTextFieldController.text.isNotEmpty) {
      searchTracksFromDatabase();
    }
  }

  void searchTracksFromDatabase() {
    searchResultTrackListFuture =
        Provider.of<DatabaseProvider>(context, listen: false).searchTracks(widget.searchTextFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Theme.of(context).colorScheme.surfaceDim,
                    child: Column(
                      children: [
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
                          tag: 'search_hero',
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: widget.searchTextFieldController,
                              focusNode: widget.searchTextFieldFocusNode,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Enter search query...',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search_rounded,
                                    size: 24,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () => setState(() {
                                    if (widget.searchTextFieldController.text.isNotEmpty) {
                                      searchTracksFromDatabase();
                                    } else {
                                      debugPrint('Search Query Empty');
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

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
                      } else if (snapshot.hasData) {
                        // debugPrint('SearchScreen snapshot.data: ${snapshot.data}');
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.surfaceDim,
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
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),

                              // Search Results ListView Builder
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
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
                                    }),
                              ),
                            ],
                          ),
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
                ],
              ),
            ),

            // Floating Action Button Play All Search Results
            Positioned(
              bottom: Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null ? 20 : 90,
              right: 10,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                onPressed: () {
                  debugPrint('Play All Search Results pressed.');
                },
                child: Icon(
                  Icons.playlist_add_rounded,
                  size: 28,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
