import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './track.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audiotags/audiotags.dart';

class AudioPlayerProvider with ChangeNotifier {
  final audioPlayer = AudioPlayer();
  String currentFilePath = '';
  // String currentDirectory = '/storage/emulated/0/Music';
  String? currentDirectory;
  Duration? currentFileDuration = Duration.zero;
  Duration? currentPlaybackPosition = Duration.zero;
  bool fileExists = false;
  bool isPlaying = false;
  String persistentMusicDirectory = "";
  List<FileSystemEntity> filesList = [];
  List<Track> trackList = [];

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    currentDirectory = await getCurrentDirectory();
    await debugLoadFilePath(); // avoid getting a null for currentDirectory manually
    await generateTrackList();
    // await setAudioPlayerFile(currentFilePath);
    audioPlayer.positionStream.listen((obtainedPosition) {
      currentPlaybackPosition = obtainedPosition;
      notifyListeners();
    });
  }

  Future<void> requestPermission() async {
    final android = await DeviceInfoPlugin().androidInfo;
    PermissionStatus storagePermissionStatus;
    PermissionStatus audioPermissionStatus;

    storagePermissionStatus = await Permission.storage.status;
    // debugPrint('Initial storage permission status: $storagePermissionStatus');
    if (storagePermissionStatus.isDenied) {
      storagePermissionStatus = await Permission.storage.request();
      // debugPrint('After requested permission status: $storagePermissionStatus');
    }
    if (storagePermissionStatus.isGranted) {
      debugPrint('Storage permission granted.');
      if (currentFilePath != '' && android.version.sdkInt < 33 && File(currentFilePath).existsSync()) {
        fileExists = true;
        notifyListeners();
      } else {
        fileExists = false;
        debugPrint("File doesn't exist.");
        notifyListeners();
      }
    } else {
      debugPrint('Storage permission denied.');
      // Handle permission denial with popup dialogue box
      // openAppSettings();
    }

    if (android.version.sdkInt >= 33) {
      audioPermissionStatus = await Permission.audio.status;
      // debugPrint('Initial audio permission status: $audioPermissionStatus');
      if (audioPermissionStatus.isDenied) {
        audioPermissionStatus = await Permission.audio.request();
        // debugPrint('After requested permission status: $audioPermissionStatus');
      }
      if (audioPermissionStatus.isGranted) {
        debugPrint('Audio permission granted.');
        if (currentFilePath != '' && android.version.sdkInt >= 33 && File(currentFilePath).existsSync()) {
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
    }
  }

  Future<void> generateTrackList() async {
    final directory = Directory(currentDirectory!);
    if (directory.existsSync()) {
      int counter = 0;
      directory.listSync(recursive: true).forEach((eachFile) async {
        // Only if .mp3 file, add to trackList
        if (eachFile is File && eachFile.path.endsWith('.mp3')) {
          // Retrieve file metadata
          try {
            Tag? metadata = await AudioTags.read(eachFile.path);
            // debugPrint('Trying file $counter, ${basenameWithoutExtension(eachFile.path)}, duration: ${metadata?.duration}');
            trackList.insert(
              counter,
              Track(
                id: counter,
                filePath: eachFile.path,
                fileName: basenameWithoutExtension(eachFile.path),
                fileLastModified: eachFile.lastModifiedSync(),
                fileDuration: Duration(seconds: metadata?.duration ?? 0),
                title: metadata?.title,
                artist: metadata?.trackArtist,
                album: metadata?.album,
                year: metadata?.year,
                albumArt: metadata?.pictures.isNotEmpty == true ? metadata?.pictures.first.bytes : null,
                genre: metadata?.genre,
                // bitrate: metadata?.bitrate,
                playCount: 0,
              ),
            );
            counter++;
          } catch (e) {
            debugPrint(
              'Error caught for file $counter, ${basenameWithoutExtension(eachFile.path)}. Error type: ${e.runtimeType}. Error details: $e',
            );
          }
        }
      });
    }
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
        currentFileDuration = await audioPlayer.load();
        notifyListeners();
      } else {
        fileExists = false;
        debugPrint("File doesn't exist.");
        notifyListeners();
      }
    }
  }

  // Remove after onboarding screen implemented
  Future<void> debugLoadFilePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fetchedMusicDirectory = prefs.getString('musicDirectory');
    if (fetchedMusicDirectory == null) {
      currentDirectory = '/storage/emulated/0/Music/new';
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

  // Future<void> playAudioPlayer() async {
  //   if (fileExists) {
  //     await audioPlayer.play();
  //     isPlaying = true;
  //     debugPrint('Playback started.');
  //   } else {
  //     debugPrint('File not found. Cannot start playback.');
  //   }
  //   notifyListeners();
  // }

  // Future<void> pauseAudioPlayer() async {
  //   if (isPlaying) {
  //     await audioPlayer.pause();
  //     debugPrint('Playback paused.');
  //     isPlaying = false;
  //   } else {
  //     debugPrint('Not playing. Cannot pause playback.');
  //   }
  //   notifyListeners();
  // }

  // Future<void> stopAudioPlayer() async {
  //   if (isPlaying) {
  //     await audioPlayer.stop();
  //     debugPrint('Playback stopped.');
  //     isPlaying = false;
  //   } else {
  //     debugPrint('Not playing. Cannot stop playback.');
  //   }
  //   notifyListeners();
  // }
}
