import 'package:flutter/material.dart';

class CustomDivider extends StatefulWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;

  const CustomDivider({
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    this.padding = const EdgeInsets.all(0),
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
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
