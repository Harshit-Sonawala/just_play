import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../main.dart';

import '../screens/home_screen.dart';
import '../screens/playlists_screen.dart';
import '../screens/shuffler_screen.dart';
import '../widgets/now_playing_menu.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  Future<List<Track>>? trackListFuture;
  int sortMode = 3;

  // @override
  // void initState() {
  //   super.initState();
  //   trackListFuture = readTracksFromDatabase();
  // }

  Future<List<Track>>? readTracksFromDatabase() async {
    if (mounted) {
      final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);
      debugPrint(
          'WrapperScreen readTracksFromDatabase() showOnboardingScreen: ${audioPlayerProviderListenFalse.prefs?.getBool('showOnboardingScreen')}\nsortMode: ${audioPlayerProviderListenFalse.prefs?.getInt('sortMode')}\n\n');
      sortMode = audioPlayerProviderListenFalse.prefs?.getInt('sortMode') ?? 3;
      final trackList = trackStoreDatabase.readAllTracksSorted(sortMode: sortMode);
      return trackList;
    }
    return [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trackListFuture = trackStoreDatabase.isTrackStoreCreated ? readTracksFromDatabase() : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    // if (!(Provider.of<DatabaseProvider>(context).isTrackDatabaseInitialized)) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text('WrapperScreen Loading Tracks...', style: Theme.of(context).textTheme.bodyLarge),
    //       const SizedBox(height: 20),
    //       const CircularProgressIndicator(),
    //     ],
    //   );
    // } else {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              children: [
                HomeScreen(
                  trackListFuture: trackListFuture,
                  onSortModeChanged: (sortMode) => {
                    setState(() {
                      // Update prefs with the chosen sortMode
                      Provider.of<AudioPlayerProvider>(context, listen: false).prefs?.setInt('sortMode', sortMode);
                      readTracksFromDatabase();
                    })
                  },
                ),
                ShufflerScreen(trackListFuture: trackListFuture),
                const PlaylistsScreen(),
              ],
            ),
            const NowPlayingMenu(),
          ],
        ),
      ),
    );
    // }
  }
}
