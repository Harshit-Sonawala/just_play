import 'dart:math'; // for Random()
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

import '../widgets/custom_grid_card.dart';
import '../widgets/custom_elevated_button.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShufflerScreen extends StatefulWidget {
  final Future<List<Track>>? trackListFuture;

  const ShufflerScreen({
    super.key,
    required this.trackListFuture,
  });

  @override
  State<ShufflerScreen> createState() => _ShufflerScreenState();
}

class _ShufflerScreenState extends State<ShufflerScreen> {
  List<Track> shuffledTrackList = [];

  // keep randomCount as a multiple of 3 since crossAxisCount = 3
  List<Track> getShuffledTrackList(List<Track> sourceTrackList, {int randomCount = 18}) {
    List<Track> shuffledTrackList = [];
    if (sourceTrackList.isEmpty) {
      return shuffledTrackList;
    }
    randomCount = min(randomCount, sourceTrackList.length); // in case sourceTrackList is smaller
    if (randomCount == 0) {
      return shuffledTrackList;
    }

    final random = Random();
    Set<int> uniqueRandomIds = {};

    while (shuffledTrackList.length < randomCount) {
      int randomId = random.nextInt(sourceTrackList.length); // add a + 1 / + 2... / + minRange

      // if not in set, skip this repeated random number
      if (!uniqueRandomIds.contains(randomId)) {
        Track foundTrack = sourceTrackList.firstWhere((eachTrack) => eachTrack.id == randomId);
        shuffledTrackList.add(foundTrack);
        uniqueRandomIds.add(randomId);
      }
    }
    return shuffledTrackList;
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appbar Header Line 1
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.casino_rounded,
                    size: 28,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Shuffler',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              Row(
                children: [
                  CustomElevatedButton(
                    onPressed: () {
                      audioPlayerProviderListenFalse.addAllToPlaylist(shuffledTrackList);
                      debugPrint('Adding All Shuffled Tracks');
                    },
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    borderRadius: 50,
                    backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                    icon: Icons.playlist_add_rounded,
                    iconSize: 22,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: 'Add All',
                    titleStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  // const SizedBox(width: 6),
                  // CustomElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       debugPrint('Re-rolled Shuffled Tracks');
                  //     });
                  //   },
                  //   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  //   borderRadius: 50,
                  //   backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                  //   icon: Icons.refresh_rounded,
                  //   iconSize: 22,
                  //   iconColor: Theme.of(context).colorScheme.secondary,
                  //   title: 'Re-roll',
                  //   titleStyle: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Appbar Header Line 2
          Text(
            'Shuffle play from a random selection of tracks. Swipe to re-roll and hold to add to up next.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),

          // Shuffled Cards FutureBuilder
          FutureBuilder<List<Track>>(
            future: widget.trackListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Loading Tracks
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Shuffling Tracks...', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                shuffledTrackList = getShuffledTrackList(snapshot.data ?? []);
                // debugPrint('ShufflerScreen shuffledTrackList Length: ${shuffledTrackList.length}');
                // debugPrint('WrapperScreen snapshot.data: ${snapshot.data}');

                // Body GridView Builder
                return Expanded(
                  // height: 600,
                  child: RefreshIndicator(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {
                      setState(() {
                        debugPrint('Re-rolled Shuffled Tracks');
                      });
                    },
                    child: MasonryGridView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      // axisDirection: AxisDirection.down,
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: shuffledTrackList.length,
                      itemBuilder: (context, index) {
                        Track eachTrack = shuffledTrackList[index];
                        // String trackTitlePhrase = eachTrack.fileName.length <= 40
                        //     ? eachTrack.fileName
                        //     : '${(eachTrack.fileName).substring(0, 41)}...';
                        return CustomGridCard(
                          onPressed: () {
                            audioPlayerProviderListenFalse.addToPlaylist(eachTrack);
                          },
                          onLongPress: () {
                            audioPlayerProviderListenFalse.addToPlaylistUpNext(eachTrack);
                          },
                          backgroundImage: eachTrack.albumArt,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (eachTrack.albumArt == null)
                                  ? Text(
                                      eachTrack.fileName[0].toUpperCase(),
                                      style: Theme.of(context).textTheme.displayLarge,
                                    )
                                  : SizedBox(height: 8),
                              SizedBox(height: 2),
                              Text(
                                '${(eachTrack.title != null && eachTrack.title!.isNotEmpty) ? eachTrack.title : eachTrack.fileName}',
                                style: Theme.of(context).textTheme.displaySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (eachTrack.artist != null && eachTrack.artist!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    // '${eachTrack.artist!.substring(0, 71)}...',
                                    '${(eachTrack.artist != null && eachTrack.artist!.isNotEmpty) ? eachTrack.artist : 'Unknown Artist'}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                // unexpected case and error encounterred
                debugPrint('ShufflerScreen Error: ${snapshot.error}');
                return Center(
                  child: Text('ShufflerScreen Error: ${snapshot.error}'),
                );
              } else {
                // unexpected case but no error encountered
                debugPrint('ShufflerScreen Unexpected: $snapshot');
                return Center(
                  child: Text('ShufflerScreen Unexpected: $snapshot'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
