import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AudioPlayerProvider with ChangeNotifier {
  final audioPlayer = AudioPlayer();
  String currentFilePath = '/storage/emulated/0/Music/01 Greyhound.mp3';
  Duration? currentFileDuration = Duration.zero;
  bool fileExists = false;
  bool isPlaying = false;

  // Omitted good practice
  // String get currentFilePath => _currentFilePath;
  // Duration? get currentFileDuration => _currentFileDuration;
  // bool get fileExists => _fileExists;
  // bool get isPlaying => _isPlaying;
  // Future<void> get toggleAudioPlayerPlayPause => _toggleAudioPlayerPlayPause();

  AudioPlayerProvider() {
    initializeAudioPlayerProvider();
  }

  Future<void> initializeAudioPlayerProvider() async {
    await requestPermission();
    await setAudioPlayerFile();
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
      debugPrint("Permission Denied.");
      // Handle permission denial with popup dialogue box
      // openAppSettings();
    }
  }

  Future<void> setAudioPlayerFile() async {
    await audioPlayer.setFilePath(currentFilePath);
    currentFileDuration = await audioPlayer.load();
    notifyListeners();
  }

  Future<void> toggleAudioPlayerPlayPause() async {
    if (!isPlaying) {
      if (fileExists) {
        await audioPlayer.play();
        isPlaying = true;
      } else {
        debugPrint("File not found."); // add toast/snackbar alert
        isPlaying = false;
      }
    } else {
      await audioPlayer.pause();
      isPlaying = false;
    }
    notifyListeners();
  }

  void updateFilePath(String newPath) {
    currentFilePath = newPath;
    setAudioPlayerFile();
    notifyListeners();
  }
}
