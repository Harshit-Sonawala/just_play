import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../objectbox.g.dart';
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
    // if (Provider.of<DatabaseProvider>(context).isTrackDatabaseInitialized) {
    //   readTracksFromDatabase();
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Provider.of<DatabaseProvider>(context).isTrackDatabaseInitialized) {
      readTracksFromDatabase();
    }
  }

  Future<void> readTracksFromDatabase() async {
    // if (!Provider.of<DatabaseProvider>(context, listen: false).isTrackDatabaseInitialized) {
    //   await Provider.of<DatabaseProvider>(context, listen: false).initializeTrackDatabase();
    // }
    if (mounted) {
      final databaseProviderListenFalse = Provider.of<DatabaseProvider>(context, listen: false);
      final audioPlayerProviderListenFalse = Provider.of<AudioPlayerProvider>(context, listen: false);

      // Read the Previously Set Sort Option from Prefs
      sortMode = audioPlayerProviderListenFalse.prefs!.getInt('sortMode') ?? 3;
      // 0 - Alpha Asc, 1 - Alpha Desc, 2 - Date Asc, 3 / Default - Date Desc
      if (sortMode == 0) {
        // no 'await' keyword as its a future we are passing to the FutureBuilder
        // Alphabetical Asc
        trackListFuture = databaseProviderListenFalse.readAllTracks();
      } else if (sortMode == 1) {
        // Alphabetical Desc
        trackListFuture =
            databaseProviderListenFalse.readAllTracksSorted(trackProperty: Track_.fileName, descending: true);
      } else if (sortMode == 2) {
        // DateModified Asc
        trackListFuture = databaseProviderListenFalse.readAllTracksSorted(trackProperty: Track_.fileLastModified);
      } else if (sortMode == 3) {
        // DateModified Desc
        trackListFuture =
            databaseProviderListenFalse.readAllTracksSorted(trackProperty: Track_.fileLastModified, descending: true);
      } else {
        debugPrint('HomeScreen Invalid sortMode: $sortMode');
        // Taking Default DateModified Desc in unexpected case
        trackListFuture =
            databaseProviderListenFalse.readAllTracksSorted(trackProperty: Track_.fileLastModified, descending: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(Provider.of<DatabaseProvider>(context).isTrackDatabaseInitialized)) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Loading Tracks...', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      );
    } else {
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
    }
  }
}
