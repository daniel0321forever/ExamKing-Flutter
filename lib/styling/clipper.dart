import 'package:flutter/material.dart';

class TopTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomRightTriangleClipper extends CustomClipper<Path> {
  final double middleHeight;
  CustomRightTriangleClipper({required this.middleHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, middleHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomLeftTriangleClipper extends CustomClipper<Path> {
  final double middleHeight;
  CustomLeftTriangleClipper({required this.middleHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, middleHeight);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
