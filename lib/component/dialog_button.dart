import 'package:flutter/material.dart';

class DialogButton extends StatefulWidget {
  final Color backgroundColor;
  final String title;
  final Function() onPressed;
  const DialogButton({
    super.key,
    this.backgroundColor = const Color.fromARGB(118, 255, 255, 255),
    required this.title,
    required this.onPressed,
  });

  @override
  State<DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<DialogButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.backgroundColor,
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }
}
