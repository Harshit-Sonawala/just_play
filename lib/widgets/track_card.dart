import 'package:flutter/material.dart';

import '../widgets/custom_card.dart';

class TrackCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final EdgeInsets padding;
  final String? trackTitle;
  final String? trackSubtitle;
  final String? trackDuration;

  const TrackCard({
    required this.onPressed,
    this.onLongPressed,
    this.padding = const EdgeInsets.all(12),
    this.trackTitle,
    this.trackSubtitle,
    this.trackDuration,
    super.key,
  });

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        borderRadius: BorderRadius.circular(10),
        child: CustomCard(
          padding: widget.padding,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CustomCard(
                      padding: EdgeInsets.all(18),
                      borderRadius: 2,
                      child: Icon(Icons.album),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trackTitle!,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.trackSubtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.trackDuration!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
