import 'package:examKing/models/level.dart';
import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';
import 'package:examKing/global/keys.dart' as keys;

Map<String, Challenge> challenges = {
  "gre1": const Challenge(
      name: "FCU",
      key: "gre",
      level: 0,
      mainColor: Color.fromARGB(255, 138, 190, 233),
      imageURL: "assets/sanrio.webp"),
  "gre2": const Challenge(
      name: "NTU",
      key: "gre",
      level: 1,
      mainColor: Color.fromARGB(255, 70, 70, 70),
      imageURL: "assets/nurse.webp"),
  "gre3": const Challenge(
      name: "Ivy League",
      key: "gre",
      level: 2,
      mainColor: Color.fromARGB(255, 235, 180, 78),
      imageURL: "assets/animal.webp"),
  "gre4": const Challenge(
      name: "MIT",
      key: "gre",
      level: 3,
      mainColor: Color.fromARGB(255, 113, 0, 148),
      imageURL: "assets/highschool.webp"),
};

Map<String, Map<String, dynamic>> statProperties = {
  keys.statTypeCorrectRate: {keys.statTitleKey: "Correct Rate"},
  keys.statTypeWinRate: {keys.statTitleKey: "Win Rate"},
  keys.statTypeAvgWords: {keys.statTitleKey: "Avg Words"},
  keys.statTypeAvgHesitation: {keys.statTitleKey: "Avg Hesitation"},
  keys.statTypeEstimatedScore: {keys.statTitleKey: "Estimated Score"},
};

List<Level> levels = [
  Level(
      level: 1,
      title: "Book 1",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 2,
      title: "Book 2",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 3,
      title: "Book 3",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 4,
      title: "Book 4",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 5,
      title: "Book 5",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 6,
      title: "Book 6",
      description: "Words we need to know",
      color: const Color.fromARGB(255, 138, 190, 233)),
  Level(
      level: 7,
      title: "Book 7",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 8,
      title: "Book 8",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 9,
      title: "Book 9",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 10,
      title: "Book 10",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 11,
      title: "Book 11",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 12,
      title: "Book 12",
      description: "Common words",
      color: const Color.fromARGB(255, 70, 70, 70)),
  Level(
      level: 15,
      title: "Book 15",
      description: "Getting high score in GRE",
      color: const Color.fromARGB(255, 235, 219, 78)),
  Level(
      level: 16,
      title: "Book 16",
      description: "Getting high score in GRE",
      color: const Color.fromARGB(255, 235, 219, 78)),
  Level(
      level: 17,
      title: "Book 17",
      description: "Becoming a GRE master",
      color: const Color.fromARGB(255, 113, 0, 148)),
  Level(
      level: 18,
      title: "Book 18",
      description: "Becoming a GRE master",
      color: const Color.fromARGB(255, 113, 0, 148)),
];
