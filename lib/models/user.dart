import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:examKing/global/keys.dart' as keys;

class UserData {
  String? googleUsername;
  String? username;
  String name;
  String photoURL;
  int winRecord;
  int loseRecord;
  double winRate;

  UserData({
    required this.googleUsername,
    required this.username,
    required this.name,
    required this.photoURL,
    required this.winRecord,
    required this.loseRecord,
    required this.winRate,
  }) {
    if (googleUsername == null && username == null) {
      debugPrint("UserData | googleUsername or username is required");
      throw Exception("Google username or username is required");
    }
  }

  factory UserData.fromMap(Map map) {
    debugPrint("UserData.fromMap | map: $map");
    UserData userData = UserData(
      googleUsername: map[keys.accountGoogleUsernameKey],
      username: map[keys.accountUsernameKey],
      name: map[keys.accountNameKey],
      photoURL: map[keys.accountPhotoURLKey],
      winRecord: map[keys.accountWinKey],
      loseRecord: map[keys.accountLoseKey],
      winRate: map[keys.accountWinRateKey],
    );

    debugPrint("UserData.fromMap | userData: $userData");

    return userData;
  }

  factory UserData.fromJson(String jsonCode) => UserData.fromMap(json.decode(jsonCode));
}
