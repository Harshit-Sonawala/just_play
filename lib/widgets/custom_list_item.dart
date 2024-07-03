import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class CustomListItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final Widget? child;
  final String? title;
  final String? artist;
  final String? album;
  final List<String>? images;
  // final List<String>? chips;

  const CustomListItem({
    required this.onPressed,
    this.onLongPress,
    this.padding = const EdgeInsets.all(0.0),
    this.child,
    this.title,
    this.artist,
    this.album,
    this.images,
    // this.chips,
    super.key,
  });

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Ink(
        height: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Provider.of<ThemeProvider>(context).globalDarkMidColor,
        ),
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.images == null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Provider.of<ThemeProvider>(context).globalDarkTopColor,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.music_note,
                      size: 22.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.images == null)
                        Text(
                          widget.title!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Row(
                        children: [
                          if (widget.artist != null)
                            Text(
                              // '${widget.artist!.substring(0, 71)}...',
                              'Artist',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Container(
                            width: 4.0,
                            height: 4.0,
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Provider.of<ThemeProvider>(context).globalDarkForegroundColor,
                            ),
                          ),
                          if (widget.album != null)
                            Text(
                              // '${widget.artist!.substring(0, 71)}...',
                              'Album',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '00:00',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
