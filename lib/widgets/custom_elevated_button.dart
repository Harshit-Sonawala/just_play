import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final String? title;
  final TextStyle? titleStyle;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? iconSize;
  final Color? iconColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomElevatedButton({
    required this.onPressed,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 10,
    this.backgroundColor,
    this.title,
    this.titleStyle,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.iconColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: widget.padding,
        minimumSize: const Size(0, 0),
        backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
        ),
      ),
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          if (widget.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? Theme.of(context).colorScheme.onSurface,
                size: widget.iconSize,
              ),
            ),
          if (widget.title != null)
            Text(
              widget.title!,
              style: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium,
            ),
          if (widget.trailingIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                widget.trailingIcon,
                color: widget.iconColor ?? Theme.of(context).colorScheme.onSurface,
                size: widget.iconSize,
              ),
            ),
        ],
      ),
    );
  }
}
