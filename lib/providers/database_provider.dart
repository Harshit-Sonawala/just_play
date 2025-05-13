import 'package:flutter/material.dart';
// import 'package:objectbox/objectbox.dart';

import '../models/track.dart';
import '../objectbox.g.dart';

class DatabaseProvider with ChangeNotifier {
  Store? trackStore; // Store is the Database equivalent
  Box<Track>? trackBox; // Box is the Table equivalent
  bool _isTrackDatabaseInitialized = false;

  bool get isTrackDatabaseInitialized => _isTrackDatabaseInitialized;

  Future<void> initializeTrackDatabase() async {
    debugPrint('DatabaseProvider Initializing Track Database.');
    trackStore = await openStore(); // Create Database
    trackBox = trackStore?.box<Track>(); // Create Table
    _isTrackDatabaseInitialized = true;
    notifyListeners();
  }

  void closeTrackDatabase() {
    trackStore?.close();
  }

  // Read all tracks
  Future<List<Track>> readAllTracks() async {
    return await trackBox!.getAllAsync();
  }

  // Read all tracks sorted by specified property, call with an underscore
  Future<List<Track>> readAllTracksSorted({
    required QueryProperty<Track, dynamic> trackProperty,
    bool descending = false,
  }) async {
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
