import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class CustomListItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final String? fileName;
  final String? title;
  final String? artist;
  final String? album;
  final Uint8List? albumArt;
  final Duration? duration;

  const CustomListItem({
    required this.onPressed,
    this.onLongPress,
    this.padding = const EdgeInsets.all(8.0),
    required this.fileName,
    this.title,
    this.artist,
    this.album,
    this.albumArt,
    this.duration,
    super.key,
  });

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  String formatDurationToString(Duration? duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration!.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (hours > 0) hours, minutes, seconds].map((seg) => seg.toString()).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      // padding: widget.padding,
      height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Provider.of<ThemeProvider>(context).globalDarkMidColor,
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.albumArt == null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.music_note,
                    size: 22.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                      image: MemoryImage(widget.albumArt!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(width: 8.0),
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
                    if (widget.artist != null && widget.artist!.isNotEmpty)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              // '${widget.artist!.substring(0, 71)}...',
                              '${(widget.artist != null && widget.artist!.isNotEmpty) ? widget.artist : 'Unknown Artist'}',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // // Separator Circle Container
                          // if (widget.artist != null && widget.album != null)
                          //   Container(
                          //     width: 4.0,
                          //     height: 4.0,
                          //     margin: const EdgeInsets.all(5.0),
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                          //     ),
                          //   ),
                          // if (widget.album != null)
                          //   Flexible(
                          //     child: Text(
                          //       // '${widget.artist!.substring(0, 71)}...',
                          //       widget.album!,
                          //       style: Theme.of(context).textTheme.bodySmall,
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                formatDurationToString(widget.duration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
