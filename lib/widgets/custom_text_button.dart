import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final BorderSide border;
  final double borderRadius;
  final Widget? child;
  final String? title;
  final IconData? icon;
  final MainAxisAlignment mainAxisAlignment;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    this.padding = const EdgeInsets.all(0),
    this.fontSize = 16,
    this.iconSize = 28,
    this.border = const BorderSide(color: Colors.transparent),
    this.borderRadius = 10,
    this.child,
    this.title,
    this.icon,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        side: widget.border,
      ),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: [
          if (widget.icon != null)
            Icon(
              widget.icon,
              size: widget.iconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (widget.icon != null && widget.title != null) const SizedBox(width: 6),
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          // if (widget.title != null) ...[
          //   const SizedBox(width: 10),
          //   Text(
          //     widget.title!,
          //     style: TextStyle(fontSize: widget.fontSize, color: Theme.of(context).colorScheme.primary),
          //   ),
          // ],
          // widget.title != null
          //     ? Text(
          //         widget.title!,
          //         style: TextStyle(fontSize: widget.fontSize, color: Theme.of(context).colorScheme.primary),
          //       )
          //     : Container(),
          widget.child ?? Container(),
        ],
      ),
    );
  }
}
