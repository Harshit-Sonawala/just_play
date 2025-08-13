import 'package:flutter/material.dart';
import 'dart:typed_data';

class CustomGridCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final double borderRadius;
  final Widget? child;
  final Uint8List? backgroundImage;
  final Color? color;

  const CustomGridCard({
    required this.onPressed,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    this.borderRadius = 10,
    this.child,
    this.backgroundImage,
    this.color,
    super.key,
  });

  @override
  State<CustomGridCard> createState() => _CustomGridCardState();
}

class _CustomGridCardState extends State<CustomGridCard> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          // width: 360,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(widget.borderRadius),
          //   color: Theme.of(context).colorScheme.surface,
          // ),
          decoration: widget.backgroundImage == null
              ? BoxDecoration(
                  color: widget.color ?? Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  image: DecorationImage(
                    image: MemoryImage(widget.backgroundImage!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
          child: InkWell(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
