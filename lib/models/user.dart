import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:examKing/global/keys.dart' as keys;

class UserData {
  String username;
  String name;
  String photoURL;
  int winRecord;
  int loseRecord;
  double winRate;

  UserData({
    required this.username,
    required this.name,
    required this.photoURL,
    required this.winRecord,
    required this.loseRecord,
    required this.winRate,
  });

  factory UserData.fromMap(Map map) {
    return UserData(
      name: map[keys.accountNameKey],
      username: map[keys.accountUsernameKey],
      photoURL: map[keys.accountPhotoURLKey],
      winRecord: map[keys.accountWinKey],
      loseRecord: map[keys.accountLoseKey],
      winRate: map[keys.accountWinRateKey],
    );
  }

  factory UserData.fromJson(String jsonCode) => UserData.fromMap(json.decode(jsonCode));
}
