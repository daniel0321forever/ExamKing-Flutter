import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final Function() onPressed;
  final String title;
  final Color? backgroundColor;
  final Color textColor;
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor,
    this.textColor = Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        width: 120,
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
