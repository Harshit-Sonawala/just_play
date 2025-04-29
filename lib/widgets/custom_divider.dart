import 'package:flutter/material.dart';

class CustomDivider extends StatefulWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? color;
  final double thickness;

  const CustomDivider({
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    this.padding = const EdgeInsets.all(0),
    this.color,
    this.thickness = 2,
    super.key,
  });

  @override
  State<CustomDivider> createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: widget.color ?? Theme.of(context).colorScheme.onSurface,
            color: widget.color ?? Theme.of(context).colorScheme.surfaceBright,
            width: widget.thickness,
          ),
        ),
      ),
    );
  }
}
