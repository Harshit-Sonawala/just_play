import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AudioPlayerProvider with ChangeNotifier {
  final audioPlayer = AudioPlayer();
  String currentFilePath = '';
  String currentDirectory = '/storage/emulated/0/Music';
  Duration? currentFileDuration = Duration.zero;
  Duration? currentPlaybackPosition = Duration.zero;
  bool fileExists = false;
  bool isPlaying = false;
  List<FileSystemEntity> filesList = [];
  String persistentMusicDirectory = "";

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    await listFiles();
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

  Future<void> listFiles() async {
    final directory = Directory(currentDirectory);
    if (directory.existsSync()) {
      filesList = directory.listSync(recursive: true);
    } else {
      debugPrint('Can\'t find directory: $currentDirectory');
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
