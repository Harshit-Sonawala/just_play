import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  // final void Function() onPressed;
  final Widget? child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final String backgroundImage;
  final String? title;
  final double? fontSize;
  final IconData? icon;
  final double? iconSize;
  final IconData? trailingIcon;
  final double? trailingIconSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomElevatedButton({
    //Key? key,
    required this.onPressed,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 10,
    this.backgroundImage = '',
    this.title,
    this.fontSize = 16,
    this.icon,
    this.iconSize = 22,
    this.trailingIcon,
    this.trailingIconSize = 22,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  }); // : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: widget.backgroundImage != ''
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
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
              // color: const Color(0xff3d3d3d),
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 46, 153, 224),
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
      child: InkWell(
        onTap: widget.onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
        ),
        child: Padding(
          padding: widget.padding!,
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: const Color(0xff1d1d1d),
                ),
              if (widget.icon != null && widget.title != null)
                const SizedBox(
                  width: 4,
                ),
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1d1d1d),
                  ),
                ),
              if (widget.trailingIcon != null && widget.title != null)
                const SizedBox(
                  width: 4,
                ),
              if (widget.trailingIcon != null)
                Icon(
                  widget.trailingIcon,
                  size: widget.trailingIconSize,
                  color: const Color(0xff1d1d1d),
                ),
              // widget.title != null
              //     ? Text(
              //         widget.title!,
              //         style: TextStyle(
              //          fontSize: widget.fontSize,
              //          color: Theme.of(context).primaryColor,
              //         ),
              //       )
              //     : Container(),
              widget.child ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
