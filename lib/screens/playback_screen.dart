import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audioplayer_provider.dart';
import '../providers/theme_provider.dart';

import '../widgets/custom_list_item.dart';
import '../widgets/custom_card.dart';

import '../screens/settings_screen.dart';

class PlaybackScreen extends StatefulWidget {
  const PlaybackScreen({super.key});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  bool isPlaying = false;

  String formatDurationToString(Duration? duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration!.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (hours > 0) hours, minutes, seconds].map((seg) => seg.toString()).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'JustPlay!',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            debugPrint("Search Button Pressed");
                          },
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  // itemExtent: 80,
                  itemCount: Provider.of<AudioPlayerProvider>(context).trackList.length,
                  itemBuilder: (context, index) {
                    final eachTrack = Provider.of<AudioPlayerProvider>(context).trackList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: CustomListItem(
                        onPressed: () {
                          Provider.of<AudioPlayerProvider>(context, listen: false)
                              .setAudioPlayerFile(eachTrack.filePath);
                        },
                        onLongPress: () {},
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
            const SizedBox(height: 10),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Decoration Handle Rectangle Container
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 24.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Provider.of<ThemeProvider>(context).globalDarkDimForegroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Provider.of<AudioPlayerProvider>(context).currentFilePath == ""
                        ? 'Select a file and JustPlay!'
                        : Provider.of<AudioPlayerProvider>(context).currentFilePath.split('/').last,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        formatDurationToString(Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Slider(
                          value:
                              Provider.of<AudioPlayerProvider>(context).currentPlaybackPosition!.inSeconds.toDouble(),
                          min: 0,
                          max: Provider.of<AudioPlayerProvider>(context).currentFileDuration!.inSeconds.toDouble(),
                          onChanged: (newSeekValue) {
                            Provider.of<AudioPlayerProvider>(context, listen: false)
                                .audioPlayer
                                .seek(Duration(seconds: newSeekValue.toInt()));
                          },
                        ),
                      ),
                      Text(
                        formatDurationToString(Provider.of<AudioPlayerProvider>(context).currentFileDuration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
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
                            if (Provider.of<AudioPlayerProvider>(context, listen: false).currentFilePath != '') {
                              if (isPlaying) {
                                isPlaying = false;
                                Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.pause();
                              } else {
                                isPlaying = true;
                                Provider.of<AudioPlayerProvider>(context, listen: false).audioPlayer.play();
                              }
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
          ],
        ),
      ),
    );
  }
}
