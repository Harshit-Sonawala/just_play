import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audiotags/audiotags.dart';

import '../models/track.dart';

class AudioPlayerProvider with ChangeNotifier {
  SharedPreferences? prefs;
  String? libraryDirectory;
  List<Track> allTracksList = [];

  final AudioPlayer audioPlayer = AudioPlayer();
  Track? _nowPlayingTrack;
  int nowPlayingIndex = -1;
  final List<Track> _playlist = [];

  // Getters and Streams
  Track? get nowPlayingTrack => _nowPlayingTrack;
  List<Track> get playlist => _playlist;
  Stream<Duration> get positionStream => audioPlayer.positionStream; // Get current playback position
  Stream<Duration?> get durationStream => audioPlayer.durationStream; // Get the song duration
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream; // Get player play/pause state
  Stream<ProcessingState> get processingStateStream => audioPlayer.processingStateStream; // Get player stopped state

  Future<void> initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs?.getBool('showOnboardingScreen') == null) {
      debugPrint('SharedPreferences: Setting default value for showOnboardingScreen.');
      await prefs?.setBool('showOnboardingScreen', true); // Default to true for the first time
    }
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

    // ERROR: DID NOT WORK
    // Current index stream listener updating on notification playback changes
    // updates _nowPlayingTrack and nowPlayingIndex
    // audioPlayer.currentIndexStream.listen((currentIndex) {
    //   nowPlayingIndex = currentIndex ?? -1;
    //   _nowPlayingTrack = (currentIndex != null) ? _playlist[currentIndex] : null;
    // });

    // sequenceStateStream listener
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState.currentSource != null) {
        final currentIndex = sequenceState.currentIndex;
        debugPrint("audioPlayer currentIndex: $currentIndex out of ${_playlist.length - 1}");
        if (nowPlayingIndex != currentIndex) {
          nowPlayingIndex = currentIndex ?? -1;
          _nowPlayingTrack = _playlist[nowPlayingIndex];
          debugPrint("nowPlayingIndex: $nowPlayingIndex, nowPlayingTrack: ${nowPlayingTrack!.fileName}");
          notifyListeners();
        }
      }
    });
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
    allTracksList = []; // empty the existingTrackList every time

    if (directory.existsSync()) {
      int fileCounter = 0;
      final files = directory.listSync(recursive: true);
      for (var eachFile in files) {
        // Only if .mp3 file, add to allTracksList
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
            // allTracksList.insert (fileCounter,tempTrack);
            allTracksList.add(tempTrack);
            // await databaseProvider.insertTrackList(allTracksList);
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
    return allTracksList;
  }

  Future<void> playTrack() async {
    await audioPlayer.play();
  }

  Future<void> pauseTrack() async {
    await audioPlayer.pause();
  }

  Future<void> stopTrack() async {
    await audioPlayer.stop();
  }

  Future<void> seekTrack(Duration newSeekValue) async {
    await audioPlayer.seek(newSeekValue);
  }

  Future<void> replayPlaylist() async {
    playIndexFromPlaylist(0);
    playTrack();
  }

  // void updateNowPlayingTrack() {
  //   final currentIndex = audioPlayer.currentIndex;
  //   nowPlayingIndex = currentIndex ?? -1;
  //   _nowPlayingTrack = (currentIndex != null) ? _playlist[currentIndex] : null;
  //   debugPrint(
  //       "updateNowPlayingTrack()\ncurrentIndex: $currentIndex\nnowPlayingIndex: $nowPlayingIndex\nnowPlayingTrack: ${nowPlayingTrack!.fileName}");
  // }

  // Convert Track type into AudioSource Type for AudioSource Playlist
  Future<AudioSource> trackToAudioSource(Track passedTrack) async {
    // Write albumArtBytes to a temp file
    Uri? albumArtUri;
    if (passedTrack.albumArt != null) {
      final tempDir = await getTemporaryDirectory();
      final artFile = File('${tempDir.path}/justplay_albumArt${passedTrack.id}.jpg');
      await artFile.writeAsBytes(passedTrack.albumArt!);
      albumArtUri = Uri.file(artFile.path);
    }

    return AudioSource.uri(
      Uri.file(passedTrack.filePath),
      tag: MediaItem(
        id: passedTrack.id.toString(),
        title: passedTrack.title ?? passedTrack.fileName,
        artist: passedTrack.artist,
        album: passedTrack.album,
        artUri: albumArtUri,
        duration: Duration(seconds: passedTrack.fileDuration),
        playable: true,
        extras: {
          'skipToPrevious': true,
          'skipToNext': true,
          // 'androidCompactActionIndices': [0, 1],
          // 'androidNotificationButtons': ['skipToPrevious', 'skipToNext'],
        },
      ),
    );
  }

  // Add to end of _playlist
  Future<void> addToPlaylist(Track trackToAdd) async {
    if (_playlist.contains(trackToAdd)) {
      debugPrint('addToPlaylist Cannot add duplicate track: ${trackToAdd.fileName}');
    } else {
      if (_playlist.isEmpty) {
        // add & play since its the only 1
        _playlist.add(trackToAdd);
        await audioPlayer.addAudioSource(await trackToAudioSource(trackToAdd));
        // _nowPlayingTrack = trackToAdd;
        // nowPlayingIndex = 0;
        playTrack();
      } else {
        _playlist.add(trackToAdd);
        await audioPlayer.addAudioSource(await trackToAudioSource(trackToAdd));
      }
      notifyListeners();
    }
  }

  // Add to the upNext of _playlist
  Future<void> addToPlaylistUpNext(Track trackToAdd) async {
    if (_playlist.contains(trackToAdd)) {
      debugPrint('addToPlaylistUpNext Cannot add duplicate track: ${trackToAdd.fileName}');
    } else {
      if (_playlist.isEmpty) {
        // add & play since its the only 1
        _playlist.add(trackToAdd);
        await audioPlayer.addAudioSource(await trackToAudioSource(trackToAdd));
        // _nowPlayingTrack = trackToAdd;
        // nowPlayingIndex = 0;
        playTrack();
      } else {
        _playlist.insert(nowPlayingIndex + 1, trackToAdd);
        await audioPlayer.insertAudioSource(nowPlayingIndex + 1, await trackToAudioSource(trackToAdd));
      }
      notifyListeners();
    }
  }

  // Remove from _playlist and update nowPlayingIndex
  Future<void> removeFromPlaylistAt(int indexToRemove) async {
    if (_playlist.isNotEmpty && indexToRemove >= 0 && indexToRemove < _playlist.length) {
      // playlist not empty && index within range && track at index exists
      if (indexToRemove == nowPlayingIndex) {
        // Removing nowPlayingTrack
        if (_playlist.length == 1) {
          // Removing nowPlayingTrack && removing last track in playlist
          await clearPlaylist();
        } else {
          // Removing nowPlayingTrack && arbitrary track
          _playlist.removeAt(indexToRemove);
          await audioPlayer.removeAudioSourceAt(indexToRemove);
          // playNextFromPlaylist(); This is handled automatically
        }
      } else if (indexToRemove < nowPlayingIndex) {
        // Removing other track before nowPlayingTrack
        _playlist.removeAt(indexToRemove);
        await audioPlayer.removeAudioSourceAt(indexToRemove);
        // nowPlayingIndex -= 1;
      } else {
        // Removing other track after nowPlayingTrack
        _playlist.removeAt(indexToRemove);
        await audioPlayer.removeAudioSourceAt(indexToRemove);
      }
      notifyListeners();
    } else {
      debugPrint('removeFromPlaylist Cannot remove track from _playlist at: $indexToRemove');
    }
  }

  // Remove all from playlists
  // Stop, reset duration to 0, clear _nowPlayingTrack & nowPlayingIndex, clear _playlist & AudioSourcesList
  Future<void> clearPlaylist() async {
    stopTrack();
    await seekTrack(Duration.zero);
    _nowPlayingTrack = null;
    nowPlayingIndex = -1;
    _playlist.clear(); // Clear _playlist
    await audioPlayer.clearAudioSources(); // Clear AudioSourcesList
    notifyListeners();
  }

  // Play next from _playlist and update nowPlayingIndex
  Future<void> playNextFromPlaylist() async {
    if (_playlist.isNotEmpty && nowPlayingIndex + 1 < _playlist.length && audioPlayer.hasNext) {
      // && _playlist[nowPlayingIndex + 1] != null)
      // playlist not empty && index within range && next track exists
      // nowPlayingIndex += 1;
      // _nowPlayingTrack = _playlist[nowPlayingIndex];
      await audioPlayer.seekToNext();
    }
    // TODO: Remove unnecessary Auto Restart if on last song
    // else if (_playlist.isNotEmpty && nowPlayingIndex + 1 == _playlist.length) {
    //   // playlist not empty && playing last song then
    //   // start from the beginning of the playlist
    //   playIndexFromPlaylist(0);
    //   notifyListeners();
    // }
    else {
      debugPrint('playNextFromPlaylist Cannot play next track at nowPlayingIndex: ${nowPlayingIndex + 1}');
    }
  }

  // Play prev from _playlist and update nowPlayingIndex
  Future<void> playPrevFromPlaylist() async {
    if (_playlist.isNotEmpty && nowPlayingIndex - 1 >= 0 && audioPlayer.hasPrevious) {
      // && _playlist[nowPlayingIndex - 1] != null)
      // playlist not empty && index within range && prev track exists
      // nowPlayingIndex -= 1;
      // _nowPlayingTrack = _playlist[nowPlayingIndex];
      await audioPlayer.seekToPrevious();
    } else {
      debugPrint('playPrevFromPlaylist Cannot play next track at nowPlayingIndex: ${nowPlayingIndex - 1}');
    }
  }

  // Play specific index from _playlist and update nowPlayingIndex
  Future<void> playIndexFromPlaylist(int indexToPlay) async {
    if (_playlist.isNotEmpty && indexToPlay >= 0 && indexToPlay < _playlist.length) {
      // && _playlist[indexToPlay] != null)
      // playlist not empty && index within range && track@index exists
      // nowPlayingIndex = indexToPlay;
      // _nowPlayingTrack = _playlist[nowPlayingIndex];
      await audioPlayer.seek(null, index: indexToPlay);
    } else {
      debugPrint('playIndexFromPlaylist Cannot play track at indexToPlay: $indexToPlay');
    }
  }

  // TODO: Remove unnecessary set track function
  // Set Track into audioPlayer
  // Future<void> setAudioPlayerFile(Track trackToPlay) async {
  //   if (File(trackToPlay.filePath).existsSync()) {
  //     _nowPlayingTrack = trackToPlay;
  //     try {
  //       // deprecated
  //       // await audioPlayer.setFilePath(trackToPlay.filePath);
  //       await audioPlayer.setAudioSource(await trackToAudioSource(trackToPlay));
  //     } catch (e) {
  //       _nowPlayingTrack = null;
  //       debugPrint(
  //           'AudioPlayerProvider setAudioPlayerFile(), Error setting file ${trackToPlay.fileName} as audio source. Error type: ${e.runtimeType}. Error details: $e');
  //     }
  //     notifyListeners();
  //   } else {
  //     _nowPlayingTrack = null;
  //     notifyListeners();
  //     debugPrint("File ${trackToPlay.filePath} doesn't exist.");
  //   }
  // }

  // TODO: Remove unnecessary auto play next function
  // Play next track on track completion with listener
  // void autoPlayNextOnTrackCompletion() {
  //   audioPlayer.processingStateStream.listen((state) {
  //     if (state == ProcessingState.completed && _playlist.length > 1) {
  //       if (nowPlayingIndex + 1 < _playlist.length) {
  //         // Play next track from playlist
  //         playNextFromPlaylist();
  //       } else {
  //         // start from the beginning of playlist
  //         playIndexFromPlaylist(0);
  //       }
  //     }
  //   });
  // }
}
