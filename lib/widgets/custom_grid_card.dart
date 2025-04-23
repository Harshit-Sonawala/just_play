import 'package:flutter/material.dart';

class CustomGridCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final double borderRadius;
  final Widget? child;
  final String backgroundImage;
  final Color? color;

  const CustomGridCard({
    required this.onPressed,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    this.borderRadius = 10,
    this.child,
    this.backgroundImage = '',
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
      child: Ink(
        // width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        // decoration: widget.backgroundImage != ''
        //     ? BoxDecoration(
        //         borderRadius: BorderRadius.circular(widget.borderRadius),
        //         image: DecorationImage(
        //           image: AssetImage(
        //             widget.backgroundImage,
        //           ),
        //           fit: BoxFit.cover,
        //           colorFilter: ColorFilter.mode(
        //             Colors.black.withOpacity(0.2),
        //             BlendMode.darken,
        //           ),
        //         ),
        //       )
        //     : BoxDecoration(
        //         color: widget.color ?? Theme.of(context).colorScheme.surface,
        //         borderRadius: BorderRadius.circular(widget.borderRadius),
        //       ),
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
    );
  }
}
