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
  final audioPlayer = AudioPlayer();
  String currentFilePath = '';
  // String currentDirectory = '/storage/emulated/0/Music';
  String? currentDirectory;
  int currentFileDuration = 0;
  int currentPlaybackPosition = 0;
  bool fileExists = false;
  bool isPlaying = false;
  String persistentMusicDirectory = "";
  List<FileSystemEntity> filesList = [];
  List<Track> trackList = [];
  var databaseProvider = DatabaseProvider();

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    currentDirectory = await getCurrentDirectory();
    // await debugLoadFilePath(); // avoid getting a null for currentDirectory manually
    // await generateTrackList();
    // await setAudioPlayerFile(currentFilePath);
    audioPlayer.positionStream.listen((obtainedPosition) {
      currentPlaybackPosition = obtainedPosition.inSeconds;
      notifyListeners();
    });
  }

  Future<void> requestPermission() async {
    final android = await DeviceInfoPlugin().androidInfo;
    int androidVersionSdkInt = android.version.sdkInt;
    PermissionStatus storagePermissionStatus;
    PermissionStatus audioPermissionStatus;

    // storage permission is deprecated for sdkInt >= 33, needs specific type of storage permission like audio
    if (androidVersionSdkInt >= 33) {
      audioPermissionStatus = await Permission.audio.status;
      // debugPrint('Initial audio permission status: $audioPermissionStatus');
      if (audioPermissionStatus.isDenied) {
        audioPermissionStatus = await Permission.audio.request();
        // debugPrint('After requested permission status: $audioPermissionStatus');
      }
      if (audioPermissionStatus.isGranted) {
        debugPrint('Audio permission granted.');
        if (currentFilePath != '' && File(currentFilePath).existsSync()) {
          fileExists = true;
          notifyListeners();
        } else {
          fileExists = false;
          debugPrint("File doesn't exist.");
          notifyListeners();
        }
      } else {
        debugPrint('Audio permission denied.');
        // Handle permission denial with popup dialogue box
        // openAppSettings();
      }
    } else {
      storagePermissionStatus = await Permission.storage.status;
      // debugPrint('Initial storage permission status: $storagePermissionStatus');
      if (storagePermissionStatus.isDenied) {
        storagePermissionStatus = await Permission.storage.request();
        // debugPrint('After requested permission status: $storagePermissionStatus');
      }
      if (storagePermissionStatus.isGranted) {
        debugPrint('Storage permission granted.');
        if (currentFilePath != '' && File(currentFilePath).existsSync()) {
          fileExists = true;
          notifyListeners();
        } else {
          fileExists = false;
          debugPrint('currentFilePath: $currentFilePath, android.version.sdkInt: $androidVersionSdkInt');
          notifyListeners();
        }
      } else {
        debugPrint('Storage permission status: $storagePermissionStatus');
        // Handle permission denial with popup dialogue box
        // openAppSettings();
      }
    }
  }

  Future<List<Track>> generateTrackList() async {
    final directory = Directory(currentDirectory!);
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
      debugPrint('AudioPlayerProvider generateTrackList(), currentDirectory: $currentDirectory doesn\'t exist');
    }
    return trackList;
  }

  Future<void> listFiles() async {
    final directory = Directory(currentDirectory!);
    if (directory.existsSync()) {
      filesList = directory.listSync(recursive: true).where((eachFile) {
        // list only files ending with .mp3
        return eachFile is File && eachFile.path.endsWith('.mp3');
      }).toList();
    } else {
      debugPrint('currentDirectory: $currentDirectory doesn\'t exist.');
    }
    notifyListeners();
  }

  Future<void> setAudioPlayerFile(String newFilePath) async {
    if (newFilePath != "") {
      currentFilePath = newFilePath;
      if (File(currentFilePath).existsSync()) {
        fileExists = true;
        await audioPlayer.setFilePath(currentFilePath);
        currentFileDuration = (await audioPlayer.load())!.inSeconds;

        notifyListeners();
      } else {
        fileExists = false;
        debugPrint("File doesn't exist.");
        notifyListeners();
      }
    }
  }

  Future<String?> getCurrentDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('musicDirectory');
  }

  Future<void> updateCurrentDirectory(String passedNewDirectory) async {
    if (passedNewDirectory != '' && Directory(passedNewDirectory).existsSync()) {
      currentDirectory = passedNewDirectory;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('musicDirectory', passedNewDirectory);
    } else {
      debugPrint('passedNewDirectory: $passedNewDirectory, either empty or does\'nt exist');
    }
  }
}
