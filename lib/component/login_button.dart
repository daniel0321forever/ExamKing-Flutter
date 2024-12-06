import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final Function() onPressed;
  final String title;
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 80,
        child: Center(child: Text(widget.title)),
      ),
    );
  }
}
