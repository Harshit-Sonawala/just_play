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
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Track? nowPlayingTrack;
  int nowPlayingTotalDuration = 0;
  int nowPlayingPosition = 0;
  List<FileSystemEntity> filesList = [];
  List<Track> trackList = [];
  var databaseProvider = DatabaseProvider();
  SharedPreferences? prefs;

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
    initializeSharedPrefs();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    libraryDirectory = await getLibraryDirectory();
    audioPlayer.positionStream.listen((obtainedPosition) {
      nowPlayingPosition = obtainedPosition.inSeconds;
      notifyListeners();
    });
  }

  Future<void> initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
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
        if (nowPlayingTrack != null &&
            nowPlayingTrack!.filePath != '' &&
            File(nowPlayingTrack!.filePath).existsSync()) {
          debugPrint(
              "androidVersionSdkInt >= 33. Audio permission granted. nowPlayingTrack: ${nowPlayingTrack!.fileName}");
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
        if (nowPlayingTrack != null &&
            nowPlayingTrack!.filePath != '' &&
            File(nowPlayingTrack!.filePath).existsSync()) {
          debugPrint(
              "androidVersionSdkInt < 33. Storage permission granted. nowPlayingTrack: ${nowPlayingTrack!.fileName}");
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
              'AudioPlayerProvider generateTrackList(), Error caught for file $fileCounter, ${basenameWithoutExtension(eachFile.path)}. Error type: ${e.runtimeType}. Error details: $e',
            );
          }
        }
      }
    } else {
      debugPrint('AudioPlayerProvider generateTrackList(), libraryDirectory: $libraryDirectory doesn\'t exist');
    }
    return trackList;
  }

  Future<void> listFiles() async {
    final directory = Directory(libraryDirectory!);
    if (directory.existsSync()) {
      filesList = directory.listSync(recursive: true).where((eachFile) {
        // list only files ending with .mp3
        return eachFile is File && eachFile.path.endsWith('.mp3');
      }).toList();
    } else {
      debugPrint('libraryDirectory: $libraryDirectory doesn\'t exist.');
    }
    notifyListeners();
  }

  Future<void> setAudioPlayerFile(Track trackToPlay) async {
    if (File(trackToPlay.filePath).existsSync()) {
      nowPlayingTrack = trackToPlay;
      await audioPlayer.setFilePath(trackToPlay.filePath);
      nowPlayingTotalDuration = (await audioPlayer.load())!.inSeconds;
      notifyListeners();
    } else {
      debugPrint("File ${trackToPlay.filePath} doesn't exist.");
    }
  }

  // Get library directory from SharedPrefs
  Future<String?> getLibraryDirectory() async {
    return prefs?.getString('musicDirectory');
  }

  // Set/update library directory in SharedPrefs
  Future<void> updateLibraryDirectory(String passedNewDirectory) async {
    if (passedNewDirectory != '' && Directory(passedNewDirectory).existsSync()) {
      libraryDirectory = passedNewDirectory;
      await prefs?.setString('musicDirectory', passedNewDirectory);
    } else {
      debugPrint('passedNewDirectory: $passedNewDirectory, either empty or does\'nt exist');
    }
  }
}
