import 'package:flutter/material.dart';
// import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';

import '../models/track.dart';

class DatabaseProvider with ChangeNotifier {
  late final Store trackStore; // Store is the Database equivalent
  late final Box<Track> trackBox; // Box is the Table equivalent

  Future<void> initializeTrackDatabase() async {
    debugPrint('DatabaseProvider Initializing Track Database.');
    trackStore = await openStore();
    trackBox = trackStore.box<Track>();

    notifyListeners();
  }

  Future<void> insertTrackList(List<Track> trackList) async {
    // TODO: Completely clear the existing database here first

    trackStore.runInTransaction(TxMode.write, () {
      for (var track in trackList) {
        trackBox.put(track);
      }
    });
    notifyListeners();
  }

  Future<List<Track>> getAllTracks() async {
    return trackBox.getAll();
  }

  // TODO: Update Database entry upon manually updating song metadata

  // TODO: Clear Database for an updated library location loading
}
