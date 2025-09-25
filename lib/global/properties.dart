import 'package:examKing/models/level.dart';
import 'package:examKing/models/subject.dart';
import 'package:examKing/pages/gre_main_page.dart';
import 'package:examKing/pages/hs_main_page.dart';
import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';
import 'package:examKing/global/keys.dart' as keys;

List<Challenge> challenges = [
  const Challenge(
      name: "7000單",
      key: "hs7000",
      level: 0,
      mainColor: Color.fromARGB(255, 138, 190, 233),
      imageURL: "assets/sanrio.webp"),
  const Challenge(
      name: "GRE",
      key: "gre",
      level: 3,
      mainColor: Color.fromARGB(255, 113, 0, 148),
      imageURL: "assets/highschool.webp"),
  const Challenge(
      name: "Chemistry",
      key: "highschool",
      level: 1,
      mainColor: Color.fromARGB(255, 70, 70, 70),
      imageURL: "assets/nurse.webp"),
  const Challenge(
      name: "Biology",
      key: "biology",
      level: 2,
      mainColor: Color.fromARGB(255, 235, 180, 78),
      imageURL: "assets/animal.webp"),
];

Map<String, Map<String, dynamic>> statProperties = {
  keys.statTypeCorrectRate: {keys.statTitleKey: "Correct Rate"},
  keys.statTypeWinRate: {keys.statTitleKey: "Win Rate"},
  keys.statTypeAvgWords: {keys.statTitleKey: "Avg Words"},
  keys.statTypeAvgHesitation: {keys.statTitleKey: "Avg Hesitation"},
  keys.statTypeEstimatedScore: {keys.statTitleKey: "Estimated Score"},
};

// Define category properties for each hs7000 level
final List<Map<String, dynamic>> hs7000Categories = [
  {
    "title": "Level 1",
    "description": "Words for kindergarten",
    "color": const Color.fromARGB(255, 81, 163, 9), // Green
  },
  {
    "title": "Level 2",
    "description": "Very easy words",
    "color": const Color.fromARGB(255, 69, 113, 149), // Blue
  },
  {
    "title": "Level 3",
    "description": "Average Junior High School level",
    "color": const Color.fromARGB(255, 168, 88, 182), // Purple
  },
  {
    "title": "Level 4",
    "description": "You are better than this",
    "color": const Color.fromARGB(255, 246, 148, 1), // Orange
  },
  {
    "title": "Level 5",
    "description": "You are embarassing your parents",
    "color": const Color.fromARGB(255, 70, 196, 183), // Pink
  },
  {
    "title": "Level 6",
    "description": "You are not good enough",
    "color": const Color.fromARGB(255, 146, 44, 35), // Cyan
  },
  {
    "title": "Level 7",
    "description": "Get average score in GSAT",
    "color": const Color.fromARGB(255, 121, 85, 72), // Brown
  },
  {
    "title": "Level 8",
    "description": "Get acceptable score in GSAT",
    "color": const Color.fromARGB(255, 96, 125, 139), // Blue Grey
  },
  {
    "title": "Level 9",
    "description": "Elite vocabulary for true mastery",
    "color": const Color.fromARGB(255, 183, 28, 28), // Deep Red
  },
];

List<List<Level>> hsLevels = List<List<Level>>.generate(9, (level) {
  final category = hs7000Categories[level];

  if (level < 8) {
    return List<Level>.generate(
      10,
      (book) => Level(
        level: level,
        book: book,
        title: "${category['title']} - Book ${book + 1}",
        description: category['description'],
        color: category['color'],
        testType: TestType.hs7000,
      ),
    );
  } else {
    return List<Level>.generate(
      5,
      (book) => Level(
        level: level,
        book: book,
        title: "${category['title']} - Book ${book + 1}",
        description: category['description'],
        color: category['color'],
        testType: TestType.hs7000,
      ),
    );
  }
});

List<Level> greLevels = [
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
];

List<Subject> subjects = [
  Subject(
    name: "GRE",
    key: "gre",
    color: const Color.fromARGB(255, 138, 170, 196),
    subColor: const Color.fromARGB(255, 8, 60, 105),
    intro: "GRE常見1000單字",
    icon: Icons.grade,
    linkedPage: const GREMainPage(),
    progress: 0.5,
  ),
  Subject(
    name: "7000單",
    key: "hs7000",
    color: const Color.fromARGB(255, 255, 195, 66),
    subColor: const Color.fromARGB(255, 176, 120, 0),
    intro: "學測、分科必備英文單字",
    icon: Icons.book,
    linkedPage: const HSMainPage(),
    progress: 0.5,
  ),
];
