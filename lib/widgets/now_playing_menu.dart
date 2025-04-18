import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_elevated_button.dart';
import '../providers/audio_player_provider.dart';

class NowPlayingMenu extends StatefulWidget {
  const NowPlayingMenu({super.key});

  @override
  State<NowPlayingMenu> createState() => _NowPlayingMenuState();
}

class _NowPlayingMenuState extends State<NowPlayingMenu> {
  // Convert fileDuration in seconds to formatted string of type 00:00
  String formatDurationIntToString(int fileDuration) {
    final hours = fileDuration ~/ 3600;
    final minutes = (fileDuration % 3600) ~/ 60;
    final seconds = fileDuration % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
    // return [if (hours > 0) hours, minutes, seconds].map((seg) => twoDigits(seg)).join(':');
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null) {
      return Container(); // empty container
    } else {
      return DraggableScrollableSheet(
        // controller: draggableScrollableSheetController,
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [0.1, 1.0],
        builder: (context, nowPlayingScrollController) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              const double expandThreshold = 200.0;
              final bool isExpanded = constraints.maxHeight > expandThreshold;

              return CustomCard(
                color: Theme.of(context).colorScheme.surface,
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

                      // Minimized Player
                      if (!isExpanded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Mini Player Album Art / Placeholder Icon
                            if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null ||
                                Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt == null)
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
                                    image: MemoryImage(
                                        Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt!),
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
                                  Text(
                                    '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title : Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.fileName}',
                                    // '${(widget.title != null && widget.title!.isNotEmpty) ? widget.title : widget.fileName}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                  ),

                                  // Mini Player Now Playing Current Position
                                  Row(
                                    children: [
                                      Text(
                                        formatDurationIntToString(
                                            Provider.of<AudioPlayerProvider>(context).nowPlayingPosition),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(
                                        ' / ',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      // Mini Player Now Playing Total Duration
                                      Text(
                                        formatDurationIntToString(
                                            Provider.of<AudioPlayerProvider>(context).nowPlayingTotalDuration),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Mini Player Controls
                            IconButton(
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                setState(() {
                                  Provider.of<AudioPlayerProvider>(context, listen: false).isPlaying
                                      ? Provider.of<AudioPlayerProvider>(context, listen: false).pauseTrack()
                                      : Provider.of<AudioPlayerProvider>(context, listen: false).playTrack();
                                });
                              },
                              icon: Icon(
                                Provider.of<AudioPlayerProvider>(context).isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      if (isExpanded) const SizedBox(height: 20),

                      // Expanded Player full-screen content
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              // Expanded Player Album Art / Placeholder Icon
                              if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null ||
                                  Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt == null)
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
                                        'assets/images/album_art_placeholder3.png',
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
                                      image: MemoryImage(
                                          Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt!),
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
                                      '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title : Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.fileName}',
                                      style: Theme.of(context).textTheme.displayLarge,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),

                                    // Expanded Player Artist
                                    if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null &&
                                        Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          // '${widget.artist!.substring(0, 71)}...',
                                          '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist : 'Unknown Artist'}',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                    // Expanded Player Album
                                    if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album != null &&
                                        Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          // '${widget.album!.substring(0, 71)}...',
                                          '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album : 'Unknown Album'}',
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
                              Column(
                                children: [
                                  // Seek Slider
                                  Slider(
                                    value: Provider.of<AudioPlayerProvider>(context).nowPlayingPosition.toDouble(),
                                    min: 0,
                                    max: Provider.of<AudioPlayerProvider>(context).nowPlayingTotalDuration.toDouble(),
                                    onChanged: (newSeekValue) {
                                      Provider.of<AudioPlayerProvider>(context, listen: false)
                                          .audioPlayer
                                          .seek(Duration(seconds: newSeekValue.toInt()));
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
                                          formatDurationIntToString(
                                              Provider.of<AudioPlayerProvider>(context).nowPlayingPosition),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),

                                        // Expanded Player Now Playing Total Duration
                                        Text(
                                          formatDurationIntToString(
                                              Provider.of<AudioPlayerProvider>(context).nowPlayingTotalDuration),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.skip_previous_rounded,
                                      size: 36,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(14),
                                      onPressed: () {
                                        setState(() {
                                          Provider.of<AudioPlayerProvider>(context, listen: false).isPlaying
                                              ? Provider.of<AudioPlayerProvider>(context, listen: false).pauseTrack()
                                              : Provider.of<AudioPlayerProvider>(context, listen: false).playTrack();
                                        });
                                      },
                                      icon: Icon(
                                        Provider.of<AudioPlayerProvider>(context).isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 40,
                                        color: Theme.of(context).colorScheme.surfaceBright,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
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
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
