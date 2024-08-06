import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/track.dart';

class DatabaseProvider with ChangeNotifier {
  Database? trackDatabase;

  DatabaseProvider() {
    initializeTrackDatabase();
  }

  Future<void> initializeTrackDatabase() async {
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
    final List<Map<String, dynamic>> allTrackMaps = await trackDatabase!.query('tracks');
    return List.generate(allTrackMaps.length, (i) {
      return Track.fromMap(allTrackMaps[i]);
    });
  }
}
