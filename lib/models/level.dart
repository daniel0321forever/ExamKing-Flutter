import "package:flutter/material.dart";

enum TestType {
  gre,
  hs7000,
}

class Level {
  final int level;
  final String title;
  final String description;
  IconData icon;
  final Color color;
  final TestType testType;
  final int? book;

  Level({
    required this.level,
    required this.title,
    required this.description,
    this.icon = Icons.circle,
    required this.color,
    this.testType = TestType.gre,
    this.book,
  });
}
