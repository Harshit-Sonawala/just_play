import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../objectbox.g.dart';
import '../providers/audio_player_provider.dart';
import '../providers/database_provider.dart';

import '../widgets/now_playing_menu.dart';
import '../screens/home_screen.dart';
import '../screens/playlists_screen.dart';

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
    readTracksFromDatabase();
  }

  void readTracksFromDatabase() {
    // Read the Previously Set Sort Option from Prefs
    sortMode = Provider.of<AudioPlayerProvider>(context, listen: false).prefs!.getInt('sortMode') ?? 3;

    // Sort the read tracks by
    // 0 - Alpha Asc
    // 1 - Alpha Desc
    // 2 - Date Asc
    // 3 / Default - Date Desc
    if (sortMode == 0) {
      // Alphabetical Asc
      // no 'await' keyword as its a future we are passing to the FutureBuilder
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false).readAllTracks();
    } else if (sortMode == 1) {
      // Alphabetical Desc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileName, descending: true);
    } else if (sortMode == 2) {
      // DateModified Asc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileLastModified);
    } else if (sortMode == 3) {
      // DateModified Desc
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileLastModified, descending: true);
    } else {
      debugPrint('HomeScreen Invalid sortMode: $sortMode');
      // Taking Default DateModified Desc in unexpected case
      trackListFuture = Provider.of<DatabaseProvider>(context, listen: false)
          .readAllTracksSorted(trackProperty: Track_.fileLastModified, descending: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
