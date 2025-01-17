import "package:flutter/material.dart";

class Level {
  final int level;
  final String title;
  final String description;
  IconData icon;
  final Color color;

  Level({
    required this.level,
    required this.title,
    required this.description,
    this.icon = Icons.circle,
    required this.color,
  });
}
