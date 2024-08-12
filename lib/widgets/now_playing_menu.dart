import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_divider.dart';
import '../providers/audio_player_provider.dart';
import '../providers/theme_provider.dart';

class NowPlayingMenu extends StatefulWidget {
  const NowPlayingMenu({super.key});

  @override
  State<NowPlayingMenu> createState() => _NowPlayingMenuState();
}

class _NowPlayingMenuState extends State<NowPlayingMenu> {
  bool isPlaying = false;

  // Convert fileDuration in seconds to formatted string of type 00:00
  String formatDurationIntToString(int fileDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = fileDuration ~/ 3600;
    final minutes = (fileDuration % 3600) ~/ 60;
    final seconds = fileDuration % 60;

    return [if (hours > 0) hours, minutes, seconds].map((seg) => twoDigits(seg)).join(':');
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null) {
      return Container(); // empty container
    } else {
      return DraggableScrollableSheet(
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 1.0,
        builder: (context, nowPlayingScrollController) {
          return CustomCard(
            child: SingleChildScrollView(
              controller: nowPlayingScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Decoration Handle Rectangle Container
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).globalDarkDimForegroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Album Art / Placeholder Icon
                      if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack == null ||
                          Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt == null)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 24.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(26.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: MemoryImage(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.albumArt!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8.0),

                      // Track Title / File Name
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title : Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.fileName}',
                              // '${(widget.title != null && widget.title!.isNotEmpty) ? widget.title : widget.fileName}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Mini Controls
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (isPlaying) {
                              Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                              isPlaying = false;
                            } else {
                              Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                              isPlaying = true;
                            }
                          });
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(),

                  // Expanded full-screen content
                  // Big Album Art / Placeholder Icon
                  Center(
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
                      ),
                      padding: const EdgeInsets.all(14.0),
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 48.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Track Information
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Track Title / File Name
                      // TODO: Wrap with Expanded() for long names?
                      Text(
                        '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.title : Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.fileName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),

                      // Artist, Separator Circle & Album
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Artist
                          if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null &&
                              Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty)
                            Flexible(
                              child: Text(
                                // '${widget.artist!.substring(0, 71)}...',
                                '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist : 'Unknown Artist'}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          // Separator Circle Container only if both are present
                          if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null &&
                              Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty &&
                              Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album != null &&
                              Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.album!.isNotEmpty)
                            Container(
                              width: 4.0,
                              height: 4.0,
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                              ),
                            ),

                          // Album
                          if (Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null &&
                              Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty)
                            Flexible(
                              child: Text(
                                // '${widget.artist!.substring(0, 71)}...',
                                '${(Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist != null && Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist!.isNotEmpty) ? Provider.of<AudioPlayerProvider>(context).nowPlayingTrack!.artist : 'Unknown Artist'}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Seek Slider & Duration Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Now Playing Position
                      Text(
                        formatDurationIntToString(Provider.of<AudioPlayerProvider>(context).nowPlayingPosition),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      // Seek Slider
                      Expanded(
                        child: Slider(
                          value: Provider.of<AudioPlayerProvider>(context).nowPlayingPosition.toDouble(),
                          min: 0,
                          max: Provider.of<AudioPlayerProvider>(context).nowPlayingTotalDuration.toDouble(),
                          onChanged: (newSeekValue) {
                            Provider.of<AudioPlayerProvider>(context, listen: false)
                                .audioPlayer
                                .seek(Duration(seconds: newSeekValue.toInt()));
                          },
                        ),
                      ),

                      // Now Playing Total Duration
                      Text(
                        formatDurationIntToString(Provider.of<AudioPlayerProvider>(context).nowPlayingTotalDuration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Full Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.skip_previous_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isPlaying) {
                              Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                              isPlaying = false;
                            } else {
                              Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                              isPlaying = true;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.skip_next_rounded,
                            size: 36,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
