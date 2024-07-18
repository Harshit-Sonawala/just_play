import 'dart:typed_data';

class Track {
  int id;
  String filePath;
  String fileName;
  DateTime fileLastModified;
  Duration fileDuration;
  String? title;
  String? artist;
  String? album;
  int? year;
  Uint8List? albumArt;
  String? genre;
  int? bitrate;
  int? playCount;

  Track({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileLastModified,
    required this.fileDuration,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.albumArt,
    this.genre,
    this.bitrate,
    this.playCount = 0,
  });
}
