import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_list_item.dart';

class NowPlayingMenu extends StatefulWidget {
  const NowPlayingMenu({super.key});

  @override
  State<NowPlayingMenu> createState() => _NowPlayingMenuState();
}

class _NowPlayingMenuState extends State<NowPlayingMenu> {
  // Convert fileDuration in seconds to formatted string of type 00:00
  String formatDuration(Duration? duration) {
    // Deprecated: removed old method based on int fileDuration
    // final hours = fileDuration ~/ 3600;
    // final minutes = (fileDuration % 3600) ~/ 60;
    // final seconds = fileDuration % 60;

    // Helper function to pad 2 digits to the left
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (duration == null) return '00:00';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

    // Selector causes rebuilds only if nowPlayingTrack changes
    return Selector<AudioPlayerProvider, Track?>(
      selector: (context, audioPlayerProvider) => audioPlayerProvider.nowPlayingTrack,
      builder: (context, nowPlayingTrack, widget) {
        if (nowPlayingTrack == null) {
          return Container();
        }

        return DraggableScrollableSheet(
          // controller: draggableScrollableSheetController,
          initialChildSize: 0.11,
          minChildSize: 0.11,
          maxChildSize: 1.0,
          snap: true,
          snapSizes: const [0.11, 1.0],
          builder: (context, nowPlayingScrollController) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double expandThreshold = 150.0;
                final bool isExpanded = constraints.maxHeight > expandThreshold;
                final String? nowPlayingTrackTitle =
                    (nowPlayingTrack.title != null && nowPlayingTrack.title!.isNotEmpty)
                        ? nowPlayingTrack.title
                        : nowPlayingTrack.fileName;

                return CustomCard(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: SingleChildScrollView(
                    controller: nowPlayingScrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Decoration Player Drag Handle Rectangle Container
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        AnimatedCrossFade(
                          firstChild: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Mini Player Album Art / Placeholder Icon
                                  if (nowPlayingTrack.albumArt == null)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).colorScheme.surfaceBright,
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      child: Icon(
                                        Icons.album_rounded,
                                        size: 28,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.all(26),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: MemoryImage(nowPlayingTrack.albumArt!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 12),

                                  // Mini Player Track Title / File Name
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        nowPlayingTrackTitle!.length > 50
                                            ? SizedBox(
                                                height: 20,
                                                child: Marquee(
                                                  text: nowPlayingTrackTitle,
                                                  // '${(widget.title != null && widget.title!.isNotEmpty) ? widget.title : widget.fileName}',
                                                  style: Theme.of(context).textTheme.displaySmall,
                                                  scrollAxis: Axis.horizontal,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  blankSpace: 200,
                                                  velocity: 60,
                                                  pauseAfterRound: const Duration(seconds: 5),
                                                ),
                                              )
                                            : Text(
                                                nowPlayingTrackTitle,
                                                // '${(nowPlayingTrack.title != null && nowPlayingTrack.title!.isNotEmpty) ? nowPlayingTrack.title : nowPlayingTrack.fileName}',
                                                style: Theme.of(context).textTheme.displaySmall,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                        // Mini Player Now Playing Duration / Position
                                        Row(
                                          children: [
                                            StreamBuilder<Duration>(
                                              stream: audioPlayerProviderListenFalse.positionStream,
                                              builder: (context, snapshot) {
                                                return Text(
                                                  formatDuration(snapshot.data ?? Duration.zero),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                );
                                              },
                                            ),
                                            Text(
                                              ' / ',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                            // Mini Player Now Playing Total Duration
                                            StreamBuilder<Duration?>(
                                              stream: audioPlayerProviderListenFalse.durationStream,
                                              builder: (context, snapshot) {
                                                return Text(
                                                  formatDuration(snapshot.data ?? Duration.zero),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Mini Player Controls
                                  StreamBuilder<ProcessingState>(
                                    stream: audioPlayerProviderListenFalse.processingStateStream,
                                    builder: (context, processingSnapshot) {
                                      final stopState = processingSnapshot.data;
                                      if (stopState == ProcessingState.completed) {
                                        return IconButton(
                                          padding: const EdgeInsets.all(10),
                                          onPressed: () {
                                            audioPlayerProviderListenFalse.seekTrack(Duration.zero);
                                            audioPlayerProviderListenFalse.playTrack();
                                          },
                                          icon: Icon(
                                            Icons.replay_rounded,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 32,
                                          ),
                                        );
                                      } else {
                                        return StreamBuilder<PlayerState>(
                                          stream: audioPlayerProviderListenFalse.playerStateStream,
                                          builder: (context, playerSnapshot) {
                                            final isPlaying = playerSnapshot.data?.playing ?? false;
                                            return IconButton(
                                              padding: const EdgeInsets.all(10),
                                              onPressed: () {
                                                isPlaying
                                                    ? audioPlayerProviderListenFalse.pauseTrack()
                                                    : audioPlayerProviderListenFalse.playTrack();
                                              },
                                              icon: Icon(
                                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: 32,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Mini Player Position / Duration LinearProgressIndicator
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: StreamBuilder<Duration?>(
                                  stream: audioPlayerProviderListenFalse.durationStream,
                                  builder: (context, durationSnapshot) {
                                    final duration = durationSnapshot.data ?? Duration.zero;
                                    final durationMs = duration.inMilliseconds.toDouble();

                                    return StreamBuilder<Duration>(
                                      stream: audioPlayerProviderListenFalse.positionStream,
                                      builder: (context, positionSnapshot) {
                                        final position = positionSnapshot.data ?? Duration.zero;
                                        final positionMs = position.inMilliseconds.toDouble();

                                        return LinearProgressIndicator(
                                          value: (positionMs / durationMs).clamp(0.0, 1.0),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).colorScheme.primary,
                                          ),
                                          backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                          minHeight: 3,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          secondChild: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            child: Column(
                              children: [
                                // Expanded Player Album Art / Placeholder Icon
                                if (nowPlayingTrack.albumArt == null)
                                  Center(
                                    child: Container(
                                      height: 350,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                      padding: const EdgeInsets.all(100),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                          'assets/images/album_art_placeholder2.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 350,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: MemoryImage(nowPlayingTrack.albumArt!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 20),

                                // Expanded Player Info Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Expanded Player Track Title / File Name
                                      Text(
                                        '${(nowPlayingTrack.title != null && nowPlayingTrack.title!.isNotEmpty) ? nowPlayingTrack.title : nowPlayingTrack.fileName}',
                                        style: Theme.of(context).textTheme.displayLarge,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),

                                      // Expanded Player Artist
                                      if (nowPlayingTrack.artist != null && nowPlayingTrack.artist!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            // '${widget.artist!.substring(0, 71)}...',
                                            '${nowPlayingTrack.artist!.isNotEmpty ? nowPlayingTrack.artist : 'Unknown Artist'}',
                                            style: Theme.of(context).textTheme.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                      // Expanded Player Album
                                      if (nowPlayingTrack.album != null && nowPlayingTrack.album!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            // '${widget.album!.substring(0, 71)}...',
                                            '${nowPlayingTrack.album!.isNotEmpty ? nowPlayingTrack.album : 'Unknown Album'}',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                      // Expanded Player Extra Controls
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CustomElevatedButton(
                                            onPressed: () {
                                              debugPrint('Add to Playlist pressed.');
                                            },
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                            borderRadius: 50,
                                            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                            icon: Icons.playlist_add_rounded,
                                            iconSize: 22,
                                            title: 'Playlist',
                                            titleStyle: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          const SizedBox(width: 10),
                                          CustomElevatedButton(
                                            onPressed: () {
                                              debugPrint('Edit Tags pressed.');
                                            },
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                            borderRadius: 50,
                                            backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                            icon: Icons.edit_rounded,
                                            iconSize: 22,
                                            title: 'Tags',
                                            titleStyle: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Expanded Player Seek Slider & Duration Progress
                                StreamBuilder<Duration?>(
                                  stream: audioPlayerProviderListenFalse.durationStream,
                                  builder: (context, durationSnapshot) {
                                    final duration = durationSnapshot.data ?? Duration.zero;
                                    final durationMs = duration.inMilliseconds.toDouble();
                                    return StreamBuilder<Duration>(
                                      stream: audioPlayerProviderListenFalse.positionStream,
                                      builder: (context, positionSnapshot) {
                                        final position = positionSnapshot.data ?? Duration.zero;
                                        final positionMs = position.inMilliseconds.toDouble();
                                        return Column(
                                          children: [
                                            Slider(
                                              // value: nowPlayingPosition.toDouble(),
                                              value: positionMs.clamp(0.0, durationMs > 0 ? durationMs : 1.0),
                                              min: 0,
                                              // max: nowPlayingTotalDuration.toDouble(),
                                              max: durationMs > 0 ? durationMs : 1.0,
                                              onChanged: (newSeekValue) {
                                                audioPlayerProviderListenFalse
                                                    .seekTrack(Duration(milliseconds: newSeekValue.toInt()));
                                              },
                                            ),

                                            // Expanded Player Seek Durations
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  // Expanded Player Now Playing Current Position
                                                  Text(
                                                    formatDuration(position),
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                  Text(
                                                    formatDuration(duration),
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),

                                // Expanded Player Full Controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.shuffle_rounded,
                                        size: 26,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        audioPlayerProviderListenFalse.playPrevFromNowPlayingList();
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        size: 36,
                                      ),
                                    ),
                                    StreamBuilder<ProcessingState>(
                                      stream: audioPlayerProviderListenFalse.processingStateStream,
                                      builder: (context, processingSnapshot) {
                                        final stopState = processingSnapshot.data;
                                        if (stopState == ProcessingState.completed) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              padding: const EdgeInsets.all(14),
                                              onPressed: () {
                                                audioPlayerProviderListenFalse.seekTrack(Duration.zero);
                                                audioPlayerProviderListenFalse.playTrack();
                                              },
                                              icon: Icon(
                                                Icons.replay_rounded,
                                                size: 40,
                                                color: Theme.of(context).colorScheme.surfaceBright,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return StreamBuilder<PlayerState>(
                                            stream: audioPlayerProviderListenFalse.playerStateStream,
                                            builder: (context, playerSnapshot) {
                                              final isPlaying = playerSnapshot.data?.playing ?? false;
                                              return Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  padding: const EdgeInsets.all(14),
                                                  onPressed: () {
                                                    isPlaying
                                                        ? audioPlayerProviderListenFalse.pauseTrack()
                                                        : audioPlayerProviderListenFalse.playTrack();
                                                  },
                                                  icon: Icon(
                                                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                                    size: 40,
                                                    color: Theme.of(context).colorScheme.surfaceBright,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        audioPlayerProviderListenFalse.playNextFromNowPlayingList();
                                      },
                                      icon: const Icon(
                                        Icons.skip_next_rounded,
                                        size: 36,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.repeat_rounded,
                                        size: 26,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Up Next ListView Builder
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Up Next',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: Provider.of<AudioPlayerProvider>(context)
                                      .nowPlayingList
                                      .asMap()
                                      .entries
                                      .map((eachEntry) {
                                    int eachTrackIndex = eachEntry.key;
                                    Track eachTrack = eachEntry.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: CustomListItem(
                                        onPressed: () {
                                          audioPlayerProviderListenFalse.playIndexFromNowPlayingList(eachTrackIndex);
                                        },
                                        onLongPress: () {
                                          audioPlayerProviderListenFalse.removeFromNowPlayingList(eachTrack);
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
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 150),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
