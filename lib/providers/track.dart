import 'dart:typed_data';

class Track {
  int? id;
  String? filePath;
  String? fileName;
  String? title;
  String? artist;
  String? album;
  int? year;
  Uint8List? albumArt;
  Duration duration;
  String? genre;
  int? bitrate;
  int? playCount;

  Track({
    required this.id,
    required this.filePath,
    required this.fileName,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.albumArt,
    required this.duration,
    this.genre,
    this.bitrate,
    this.playCount = 0,
  });
}
