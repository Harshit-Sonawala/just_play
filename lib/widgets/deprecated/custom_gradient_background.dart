import 'package:flutter/material.dart';

class CustomGradientBackground extends StatefulWidget {
  final Widget? child;
  const CustomGradientBackground({this.child, super.key});

  @override
  State<CustomGradientBackground> createState() => _CustomGradientBackgroundState();
}

class _CustomGradientBackgroundState extends State<CustomGradientBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Color.fromARGB(178, 18, 165, 218),
            // Color.fromARGB(166, 12, 110, 146),
            // Color.fromARGB(172, 11, 109, 145),
            Color(0xff3d3d3d),
            Color(0xff2d2d2d),
            Color(0xff1d1d1d),
            Color(0xff1d1d1d),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
