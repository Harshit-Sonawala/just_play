import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';

@Entity()
class Track {
  @Id(assignable: true)
  int id;

  @Unique()
  String filePath;

  String fileName;

  @Property(type: PropertyType.date)
  DateTime fileLastModified;

  int fileDuration;
  String? title;
  String? artist;
  String? album;
  int? year;

  @Property(type: PropertyType.byteVector)
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

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'filePath': filePath,
//       'fileName': fileName,
//       'fileLastModified': fileLastModified.millisecondsSinceEpoch,
//       'fileDuration': fileDuration,
//       'title': title,
//       'artist': artist,
//       'album': album,
//       'year': year,
//       'albumArt': albumArt,
//       'genre': genre,
//       'bitrate': bitrate,
//       'playCount': playCount,
//     };
//   }

//   static Track fromMap(Map<String, dynamic> map) {
//     return Track(
//       id: map['id'],
//       filePath: map['filePath'],
//       fileName: map['fileName'],
//       fileLastModified: DateTime.fromMillisecondsSinceEpoch(map['fileLastModified']),
//       fileDuration: map['fileDuration'],
//       title: map['title'],
//       artist: map['artist'],
//       album: map['album'],
//       year: map['year'],
//       albumArt: map['albumArt'],
//       genre: map['genre'],
//       bitrate: map['bitrate'],
//       playCount: map['playCount'],
//     );
//   }
