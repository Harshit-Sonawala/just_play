import 'dart:typed_data';
import 'package:flutter/material.dart';

class CustomListItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final String? fileName;
  final String? title;
  final String? artist;
  final String? album;
  final Uint8List? albumArt;
  final int duration;

  const CustomListItem({
    required this.onPressed,
    this.onLongPress,
    this.padding = const EdgeInsets.fromLTRB(6, 4, 16, 4),
    required this.fileName,
    this.title,
    this.artist,
    this.album,
    this.albumArt,
    required this.duration,
    super.key,
  });

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  // Convert fileDuration in seconds to formatted string of type 00:00
  String formatDurationIntToString(int fileDuration) {
    final hours = fileDuration ~/ 3600;
    final minutes = (fileDuration % 3600) ~/ 60;
    final seconds = fileDuration % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
    // return [if (hours > 0) hours, minutes, seconds].map((seg) => twoDigits(seg)).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        // padding: widget.padding,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.albumArt == null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.surfaceBright,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 24.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: MemoryImage(widget.albumArt!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),

                // Track Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(widget.title != null && widget.title!.isNotEmpty) ? widget.title : widget.fileName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Artist String
                          if (widget.artist != null && widget.artist!.isNotEmpty)
                            Flexible(
                              child: Text(
                                // '${widget.artist!.substring(0, 71)}...',
                                '${(widget.artist != null && widget.artist!.isNotEmpty) ? widget.artist : 'Unknown Artist'}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          // Artist Separator Circle Container
                          if (widget.artist != null && widget.artist!.isNotEmpty)
                            Container(
                              width: 4.0,
                              height: 4.0,
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),

                          // Album String
                          if (widget.album != null && widget.album!.isNotEmpty)
                            Flexible(
                              child: Text(
                                // '${widget.album!.substring(0, 71)}...',
                                widget.album!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          // Album Separator Circle Container
                          if (widget.album != null && widget.album!.isNotEmpty)
                            Container(
                              width: 4.0,
                              height: 4.0,
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),

                          // Duration Text
                          Text(
                            formatDurationIntToString(widget.duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
