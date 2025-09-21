import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPageButton extends StatefulWidget {
  final Function() onPressed;
  final String title;
  final Color backgroundColor;
  final Color textColor;
  const MainPageButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  });

  @override
  State<MainPageButton> createState() => _MainPageButtonState();
}

class _MainPageButtonState extends State<MainPageButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: widget.backgroundColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: widget.backgroundColor.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: 150,
        child: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.mandali(
              fontSize: 20,
              color: widget.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
