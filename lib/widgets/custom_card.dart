import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double borderRadius;
  final Widget? child;
  final String backgroundImage;
  final Color? color;

  const CustomCard({
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 10,
    this.margin,
    this.child,
    this.backgroundImage = '',
    this.color = const Color(0xff222222),
    super.key,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: widget.margin,
      padding: widget.padding,
      decoration: widget.backgroundImage != ''
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              image: DecorationImage(
                image: AssetImage(
                  widget.backgroundImage,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            )
          : BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(10),
            ),
      child: widget.child,
    );
  }
}
