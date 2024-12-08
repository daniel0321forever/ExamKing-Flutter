import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';

Map<String, Challenge> challenges = {
  "sanrio": const Challenge(name: "三麗鷗", key: "sanrio", mainColor: Color.fromARGB(255, 146, 0, 0), imageURL: "assets/sanrio.jpg"),
  "nursing": const Challenge(name: "護理", key: "nursing", mainColor: Color.fromARGB(255, 117, 1, 184), imageURL: "assets/nurse.jpg"),
  "biology": const Challenge(name: "生物", key: "biology", mainColor: Color.fromARGB(255, 31, 130, 97), imageURL: "assets/highschool.jpeg"),
  // "highschool": const Challenge(name: "高中", key: "highschool", mainColor: Color.fromARGB(255, 255, 26, 26), imageURL: "assets/highschool.jpeg"),
};
