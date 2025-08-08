import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';

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
  int? sortMode;

  @override
  void initState() {
    super.initState();
    trackListFuture = readTracksFromDatabase();
  }

  Future<List<Track>>? readTracksFromDatabase() async {
    if (mounted) {
      final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);
      final databaseProviderListenFalse = Provider.of<DatabaseProvider>(context, listen: false);

      /* if (!(audioPlayerProviderListenFalse.prefs?.getBool('showOnboardingScreen') ?? true)) {
        await databaseProviderListenFalse.initializeTrackDatabase();
      } */

      debugPrint(
          '\n\nWrapperScreen readTracksFromDatabase() showOnboardingScreen: ${audioPlayerProviderListenFalse.prefs?.getBool('showOnboardingScreen')}\nsortMode: ${audioPlayerProviderListenFalse.prefs?.getInt('sortMode')}\n\n');
      // Read the Previously Set Sort Option from Prefs
      sortMode = audioPlayerProviderListenFalse.prefs?.getInt('sortMode') ?? 3;
      return databaseProviderListenFalse.readAllTracksSorted(sortMode: sortMode);
    }
    return [];
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
