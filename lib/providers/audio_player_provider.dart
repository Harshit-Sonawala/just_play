import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audiotags/audiotags.dart';

import '../models/track.dart';
import './database_provider.dart';

class AudioPlayerProvider with ChangeNotifier {
  String persistentMusicDirectory = "";
  String? libraryDirectory;
  final AudioPlayer audioPlayer = AudioPlayer();
  Track? _nowPlayingTrack;
  // List<FileSystemEntity> filesList = [];
  List<Track> trackList = [];
  var databaseProvider = DatabaseProvider();
  SharedPreferences? prefs;

  // Getters and Streams
  Track? get nowPlayingTrack => _nowPlayingTrack;
  Stream<Duration> get positionStream => audioPlayer.positionStream; // Get current playback position
  Stream<Duration?> get durationStream => audioPlayer.durationStream; // Get the song duration
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream; // Get player play/pause state
  Stream<ProcessingState> get processingStateStream => audioPlayer.processingStateStream; // Get player stopped state

  // Initialize
  AudioPlayerProvider() {
    initializeSharedPrefs();
    initializeAudioPlayerProvider();
  }

  Future<void> initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Get music library directory from SharedPrefs
  Future<String?> getLibraryDirectory() async {
    return prefs?.getString('musicDirectory');
  }

  // Set/update music library directory in SharedPrefs
  Future<void> updateLibraryDirectory(String updatedLibraryDirectory) async {
    if (updatedLibraryDirectory.isNotEmpty && Directory(updatedLibraryDirectory).existsSync()) {
      libraryDirectory = updatedLibraryDirectory;
      await prefs?.setString('musicDirectory', updatedLibraryDirectory);
    } else {
      debugPrint('updatedLibraryDirectory: $updatedLibraryDirectory, either empty or does\'nt exist');
    }
  }

  // Initialize with LibraryDirectory
  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    libraryDirectory = await getLibraryDirectory();

    // Deprecated: positionStream Listener causing constant rebuilds
    // audioPlayer.positionStream.listen((obtainedPosition) {
    //   // nowPlayingPosition = obtainedPosition.inSeconds; // returns int
    //   notifyListeners();
    // });
  }

  Future<void> requestPermission() async {
    final android = await DeviceInfoPlugin().androidInfo;
    int androidVersionSdkInt = android.version.sdkInt;
    PermissionStatus storagePermissionStatus;
    PermissionStatus audioPermissionStatus;

    // storage permission is deprecated for sdkInt >= 33, needs specific type like audio permission
    if (androidVersionSdkInt >= 33) {
      audioPermissionStatus = await Permission.audio.status;
      // debugPrint('androidVersionSdkInt >= 33. Initial audio permission status: $audioPermissionStatus');
      if (audioPermissionStatus.isDenied) {
        audioPermissionStatus = await Permission.audio.request();
        // debugPrint('androidVersionSdkInt >= 33. After requested permission status: $audioPermissionStatus');
      }
      if (audioPermissionStatus.isGranted) {
        if (_nowPlayingTrack != null &&
            _nowPlayingTrack!.filePath != '' &&
            File(_nowPlayingTrack!.filePath).existsSync()) {
          debugPrint(
              "androidVersionSdkInt >= 33. Audio permission granted. _nowPlayingTrack: ${_nowPlayingTrack!.fileName}");
        } else {
          debugPrint("androidVersionSdkInt >= 33. Audio permission granted. No playback track loaded.");
        }
      } else {
        debugPrint('androidVersionSdkInt >= 33. Audio permission denied.');
        // Handle permission denial with popup dialogue box
        // openAppSettings();
      }
    } else {
      // androidVersionSdkInt < 33, needs storage permission
      storagePermissionStatus = await Permission.storage.status;
      // debugPrint('androidVersionSdkInt < 33. Initial storage permission status: $storagePermissionStatus');
      if (storagePermissionStatus.isDenied) {
        storagePermissionStatus = await Permission.storage.request();
        // debugPrint('androidVersionSdkInt < 33. After requested permission status: $storagePermissionStatus');
      }
      if (storagePermissionStatus.isGranted) {
        debugPrint('androidVersionSdkInt < 33. Storage permission granted.');
        if (_nowPlayingTrack != null &&
            _nowPlayingTrack!.filePath != '' &&
            File(_nowPlayingTrack!.filePath).existsSync()) {
          debugPrint(
              "androidVersionSdkInt < 33. Storage permission granted. _nowPlayingTrack: ${_nowPlayingTrack!.fileName}");
        } else {
          debugPrint('androidVersionSdkInt < 33. Storage permission granted. No playback track loaded.');
        }
      } else {
        debugPrint('androidVersionSdkInt < 33. Storage permission denied.');
        // Handle permission denial with popup dialogue box
        // openAppSettings();
      }
    }
  }

  // During onboarding, build music database for the first time
  Future<List<Track>> generateTrackList() async {
    final directory = Directory(libraryDirectory!);
    trackList = []; // empty the existingTrackList every time

    if (directory.existsSync()) {
      int fileCounter = 0;
      final files = directory.listSync(recursive: true);
      for (var eachFile in files) {
        // Only if .mp3 file, add to trackList
        if (eachFile is File && eachFile.path.endsWith('.mp3')) {
          // Retrieve file metadata or catch error
          try {
            Tag? metadata = await AudioTags.read(eachFile.path);
            // debugPrint('Trying file $fileCounter, ${basenameWithoutExtension(eachFile.path)}, duration: ${metadata?.duration}');
            Track tempTrack = Track(
              id: fileCounter,
              filePath: eachFile.path,
              fileName: basenameWithoutExtension(eachFile.path),
              fileLastModified: eachFile.lastModifiedSync(),
              // fileDuration: Duration(seconds: metadata?.duration ?? 0),
              fileDuration: metadata?.duration ?? 0,
              title: metadata?.title,
              artist: metadata?.trackArtist,
              album: metadata?.album,
              year: metadata?.year,
              albumArt: (metadata?.pictures.isNotEmpty == true) ? metadata?.pictures.first.bytes : null,
              genre: metadata?.genre,
              // bitrate: metadata?.bitrate,
              playCount: 0,
            );
            // trackList.insert (fileCounter,tempTrack);
            trackList.add(tempTrack);
            // await databaseProvider.insertTrackList(trackList);
            fileCounter++;
          } catch (e) {
            debugPrint(
                'AudioPlayerProvider generateTrackList(), Error caught for file $fileCounter, ${basenameWithoutExtension(eachFile.path)}. Error type: ${e.runtimeType}. Error details: $e');
          }
        }
      }
    } else {
      debugPrint('AudioPlayerProvider generateTrackList(), libraryDirectory: $libraryDirectory doesn\'t exist');
    }
    return trackList;
  }

  // Deprecated Unused listFiles() Function
  // Future<void> listFiles() async {
  //   final directory = Directory(libraryDirectory!);
  //   if (directory.existsSync()) {
  //     filesList = directory.listSync(recursive: true).where((eachFile) {
  //       // list only files ending with .mp3
  //       return eachFile is File && eachFile.path.endsWith('.mp3');
  //     }).toList();
  //   } else {
  //     debugPrint('libraryDirectory: $libraryDirectory doesn\'t exist.');
  //   }
  //   notifyListeners();
  // }

  Future<void> setAudioPlayerFile(Track trackToPlay) async {
    if (File(trackToPlay.filePath).existsSync()) {
      _nowPlayingTrack = trackToPlay;
      try {
        await audioPlayer.setFilePath(trackToPlay.filePath);
      } catch (e) {
        _nowPlayingTrack = null;
        debugPrint(
            'AudioPlayerProvider setAudioPlayerFile(), Error setting file ${trackToPlay.fileName} as audio source. Error type: ${e.runtimeType}. Error details: $e');
      }
      // Now durationStream will handle duration.
      // Deprecated: removed positionStream Listener method of obtaining updated duration
      // nowPlayingTotalDuration = (await audioPlayer.load())!.inSeconds;
      notifyListeners();
    } else {
      _nowPlayingTrack = null;
      notifyListeners();
      debugPrint("File ${trackToPlay.filePath} doesn't exist.");
    }
  }

  Future<void> playTrack() async {
    audioPlayer.play();
  }

  Future<void> pauseTrack() async {
    audioPlayer.pause();
  }

  Future<void> seekTrack(Duration newSeekValue) async {
    audioPlayer.seek(newSeekValue);
  }
}
