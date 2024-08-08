import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/track.dart';

class DatabaseProvider with ChangeNotifier {
  Database? trackDatabase;

  // DatabaseProvider() {
  //   initializeTrackDatabase();
  // }

  Future<void> initializeTrackDatabase() async {
    debugPrint('database_provider: Initializing Track Database.');
    WidgetsFlutterBinding.ensureInitialized(); // avoid errors
    trackDatabase = await openDatabase(
      join(await getDatabasesPath(), 'track_database.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tracks (
            id INTEGER PRIMARY KEY,
            filePath TEXT,
            fileName TEXT,
            fileLastModified INTEGER,
            fileDuration INTEGER,
            title TEXT,
            artist TEXT,
            album TEXT,
            year INTEGER,
            albumArt BLOB,
            genre TEXT,
            bitrate INTEGER,
            playCount INTEGER
          );
        ''');
      },
    );
    notifyListeners();
  }

  Future<void> insertTrack(track) async {
    await trackDatabase?.insert(
      'tracks', // table name
      track.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  // Future<void> insertTrackList(List<Track> trackList) async {
  //   for (Track eachTrack in trackList) {
  //     await trackDatabase?.insert(
  //       'tracks', // table name
  //       eachTrack.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   }
  //  notifyListeners();
  // }

  Future<List<Track>> getAllTracks() async {
    final List<Map<String, dynamic>> allTrackMaps = [];
    int offset = 0;
    const int limit = 100;

    while (true) {
      List<Map<String, dynamic>> batch = await trackDatabase!.query(
        'tracks',
        limit: limit,
        offset: offset,
      );
      if (batch.isEmpty) {
        break;
      }
      allTrackMaps.addAll(batch);
      offset += limit;
    }

    return List.generate(
      allTrackMaps.length,
      (eachTrackMap) => Track.fromMap(allTrackMaps[eachTrackMap]),
    );
  }
}