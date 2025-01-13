import 'package:examKing/models/level.dart';
import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';
import 'package:examKing/global/keys.dart' as keys;

Map<String, Challenge> challenges = {
  "1": const Challenge(name: "High School", key: "gre", mainColor: Color.fromARGB(255, 138, 190, 233), imageURL: "assets/sanrio.webp"),
  "2": const Challenge(name: "Community College", key: "gre", mainColor: Color.fromARGB(255, 70, 70, 70), imageURL: "assets/nurse.webp"),
  "3": const Challenge(name: "Ivy League", key: "gre", mainColor: Color.fromARGB(255, 235, 180, 78), imageURL: "assets/animal.webp"),
  "4": const Challenge(name: "MIT", key: "gre", mainColor: Color.fromARGB(255, 113, 0, 148), imageURL: "assets/highschool.webp"),
};

Map<String, Map<String, dynamic>> statProperties = {
  keys.statTypeCorrectRate: {keys.statTitleKey: "Correct Rate"},
  keys.statTypeWinRate: {keys.statTitleKey: "Win Rate"},
  keys.statTypeAvgWords: {keys.statTitleKey: "Avg Words"},
  keys.statTypeAvgHesitation: {keys.statTitleKey: "Avg Hesitation"},
  keys.statTypeEstimatedScore: {keys.statTitleKey: "Estimated Score"},
};

List<Level> levels = [
  Level(level: 0, title: "Basic 1", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 1, title: "Basic 2", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 2, title: "Basic 3", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 3, title: "Basic 4", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 4, title: "Basic 5", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 5, title: "Basic 6", description: "Words we need to know", color: const Color.fromARGB(255, 138, 190, 233)),
  Level(level: 7, title: "Intermediate 1", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 8, title: "Intermediate 2", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 9, title: "Intermediate 3", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 10, title: "Intermediate 4", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 11, title: "Intermediate 5", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 12, title: "Intermediate 6", description: "Common words", color: const Color.fromARGB(255, 70, 70, 70)),
  Level(level: 15, title: "Advanced 1", description: "Getting high score in GRE", color: const Color.fromARGB(255, 235, 219, 78)),
  Level(level: 16, title: "Advanced 2", description: "Getting high score in GRE", color: const Color.fromARGB(255, 235, 219, 78)),
  Level(level: 17, title: "Expert 1", description: "Becoming a GRE master", color: const Color.fromARGB(255, 113, 0, 148)),
  Level(level: 18, title: "Expert 2", description: "Becoming a GRE master", color: const Color.fromARGB(255, 113, 0, 148)),
];
