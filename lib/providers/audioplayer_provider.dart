import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AudioPlayerProvider with ChangeNotifier {
  final audioPlayer = AudioPlayer();
  String currentFilePath = '/storage/emulated/0/Music/09. Alan Walker - Faded.mp3';
  Duration? currentFileDuration = Duration.zero;
  Duration? currentPlaybackPosition = Duration.zero;
  bool isPlaying = false;
  bool fileExists = false;

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    await setAudioPlayerFile(currentFilePath);
    audioPlayer.positionStream.listen((obtainedPosition) {
      currentPlaybackPosition = obtainedPosition;
      notifyListeners();
    });
  }

  Future<void> requestPermission() async {
    final android = await DeviceInfoPlugin().androidInfo;
    Permission selectedPermissionType;

    if (android.version.sdkInt < 33) {
      selectedPermissionType = Permission.storage;
    } else {
      selectedPermissionType = Permission.audio;
    }

    PermissionStatus permissionStatus = await selectedPermissionType.status;
    // debugPrint('Initial permission status: $permissionStatus');

    if (permissionStatus.isDenied) {
      permissionStatus = await selectedPermissionType.request();
      // debugPrint('After requested permission status: $permissionStatus');
    }

    if (permissionStatus.isGranted) {
      if (File(currentFilePath).existsSync()) {
        fileExists = true;
        notifyListeners();
      } else {
        fileExists = false;
        debugPrint("File doesn't exist.");
        notifyListeners();
      }
    } else {
      debugPrint('Permission Denied.');
      // Handle permission denial with popup dialogue box
      // openAppSettings();
    }
  }

  Future<void> setAudioPlayerFile(String newFilePath) async {
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
