import 'package:flutter/material.dart';

class Challenge {
  final String name;
  final String key;
  final int? level;
  final Color mainColor;
  final String imageURL;
  const Challenge({
    required this.name,
    required this.key,
    required this.mainColor,
    required this.imageURL,
    this.level,
  });
}
