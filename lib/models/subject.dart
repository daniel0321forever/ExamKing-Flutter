import 'package:flutter/material.dart';

class Subject {
  final String name;
  final String key;
  final Color color;
  final Color subColor;
  double progress;
  final String intro;
  final IconData icon;
  final Widget linkedPage;

  Subject({
    required this.name,
    required this.key,
    required this.color,
    required this.subColor,
    this.progress = 0,
    required this.intro,
    required this.icon,
    required this.linkedPage,
  });
}
