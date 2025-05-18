import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:objectbox/objectbox.dart';

import '../models/track.dart';
import '../objectbox.g.dart';

class DatabaseProvider with ChangeNotifier {
  late final Store trackStore; // Store is the Database equivalent
  late final Box<Track> trackBox; // Box is the Table equivalent
  late bool isTrackStoreInit;

  Future<void> initializeTrackDatabase() async {
    WidgetsFlutterBinding.ensureInitialized(); // ensure ObjectBox can get the application directory
    final appDocsDir = await getApplicationDocumentsDirectory();

    try {
      debugPrint('DatabaseProvider Trying to Initialize Track Database...');
      trackStore = await openStore(directory: join(appDocsDir.path, "track-store")); // Create Database
      trackBox = trackStore.box<Track>(); // Create Table
      debugPrint('DatabaseProvider Track Database Initialized Successfully.');
    } catch (err) {
      debugPrint('\nDatabaseProvider initializeTrackDatabase Error: $err');

      // Catch another store still open using same path error
      if (err.toString().contains('another store is still open using the same path')) {
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('Trying to close store and reinitialize...');
        closeTrackDatabase();
        // Try Again
        try {
          trackStore = await openStore(directory: join(appDocsDir.path, "track-store"));
          trackBox = trackStore.box<Track>();
          debugPrint('DatabaseProvider Track Database Reinitialized Successfully.');
        } catch (retryErr) {
          debugPrint('\nDatabaseProvider initializeTrackDatabase Failed to Reinitialize: $retryErr');
        }
      }
    }
  }

  void closeTrackDatabase() {
    trackStore.close();
    notifyListeners();
    debugPrint('DatabaseProvider Track Database Closed.');
  }

  // Read all tracks
  Future<List<Track>> readAllTracks() async {
    return await trackBox?.getAllAsync() ?? [];
  }

  // Read all tracks sorted by specified property
  Future<List<Track>> readAllTracksSorted({int? sortMode = 3}) async {
    QueryProperty<Track, dynamic> trackProperty;
    bool descending;

    if (sortMode == 0) {
      // Filename Asc
      trackProperty = Track_.fileName;
      descending = false;
    } else if (sortMode == 1) {
      // Filename Desc
      trackProperty = Track_.fileName;
      descending = true;
    } else if (sortMode == 2) {
      // Modified Asc
      trackProperty = Track_.fileLastModified;
      descending = false;
    } else {
      // Modified Desc
      trackProperty = Track_.fileLastModified;
      descending = true;
    }

    QueryBuilder<Track> queryBuilder = trackBox!.query()
      ..order(trackProperty, flags: descending ? Order.descending : 0);

    Query<Track> sortedQuery = queryBuilder.build();
    List<Track> result = await sortedQuery.findAsync();
    sortedQuery.close();
    return result;
  }

  // Search for tracks based on searchKey passed
  Future<List<Track>> searchTracks(String searchKey) async {
    Query<Track> searchQuery = trackBox!
        .query(
          Track_.filePath.contains(searchKey) |
              Track_.fileName.contains(searchKey) |
              Track_.title.contains(searchKey) |
              Track_.artist.contains(searchKey) |
              Track_.album.contains(searchKey),
        )
        .build();
    List<Track> result = await searchQuery.findAsync();
    searchQuery.close();
    return result;
  }

  // Insert one track
  Future<void> insertTrack(Track track) async {
    await trackBox!.putAsync(track);
    notifyListeners();
  }

  // Insert multiple tracks
  Future<void> insertTrackList(List<Track> trackList) async {
    await trackBox!.putManyAsync(trackList);
    notifyListeners();
  }

  // Delete specific track
  Future<void> deleteTrack(Track track) async {
    await trackBox!.removeAsync(track.id);
    notifyListeners();
  }

  // Delete multiple specific tracks
  Future<void> deleteTrackList(List<Track> trackList) async {
    List<int> trackIdList = trackList.map((eachTrack) => eachTrack.id).toList();
    await trackBox!.removeManyAsync(trackIdList);
    notifyListeners();
  }

  // Delete all tracks
  Future<void> deleteAllTracks() async {
    await trackBox!.removeAllAsync();
    notifyListeners();
  }

  // Return count of tracks
  int returnTotalTrackCount() {
    return trackBox!.count();
  }

  // Update Database entry upon manually updating song metadata
}
