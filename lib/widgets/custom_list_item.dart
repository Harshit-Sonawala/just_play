import 'package:flutter/material.dart';

import './custom_divider.dart';

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
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff222222),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.images != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        widget.images![0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withAlpha(0),
                          Colors.black38,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.images == null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xff333333),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: const Icon(
                          Icons.music_note,
                          size: 14.0,
                        ),
                      ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xfff3f3f3),
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
            ],
          ),
        ),
      ),
    );
  }
}
