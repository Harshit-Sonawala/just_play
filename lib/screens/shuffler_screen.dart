import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

import '../widgets/custom_grid_card.dart';

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

      if (!uniqueRandomIds.contains(randomId)) {
        Track foundTrack = sourceTrackList.firstWhere((eachTrack) => eachTrack.id == randomId);
        shuffledTrackList.add(foundTrack);
        uniqueRandomIds.add(randomId);
      }
    }

    // for (int i = 0; i < randomCount; i++) {
    //   int randomId = random.nextInt(sourceTrackList.length); // add a + 1 / + 2... / + minRange
    //   shuffledTrackList.add(sourceTrackList[randomId]);
    // }
    return shuffledTrackList;
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appbar Line 1
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
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
              ],
            ),
          ),

          // Appbar Line 2
          Text(
            'Shuffle play from a wider more random selection of tracks:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),

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
                final shuffledTrackList = getShuffledTrackList(snapshot.data!);
                debugPrint('ShufflerScreen shuffledTrackList Length: ${shuffledTrackList.length}');
                // debugPrint('WrapperScreen snapshot.data: ${snapshot.data}');
                return Expanded(
                  // height: 600,
                  child: MasonryGridView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    // axisDirection: AxisDirection.down,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    // crossAxisCount: 4,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    itemCount: shuffledTrackList.length,
                    itemBuilder: (context, index) {
                      Track eachTrack = shuffledTrackList[index];
                      return CustomGridCard(
                        onPressed: () {
                          // Provider.of<AudioPlayerProvider>(context, listen: false).setAudioPlayerFile(eachTrack);
                          audioPlayerProviderListenFalse.addToNowPlayingList(eachTrack);
                        },
                        onLongPress: () {
                          audioPlayerProviderListenFalse.addToNowPlayingListUpNext(eachTrack);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Icon(Icons.music_note_rounded, size: 16),
                            Text(
                              '${(eachTrack.title != null && eachTrack.title!.isNotEmpty) ? eachTrack.title : eachTrack.fileName}',
                              style: Theme.of(context).textTheme.displaySmall,
                              // maxLines: 4,
                              // overflow: TextOverflow.ellipsis,
                            ),
                            if (eachTrack.artist != null && eachTrack.artist!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  // '${eachTrack.artist!.substring(0, 71)}...',
                                  '${(eachTrack.artist != null && eachTrack.artist!.isNotEmpty) ? eachTrack.artist : 'Unknown Artist'}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  // maxLines: 4,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
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
