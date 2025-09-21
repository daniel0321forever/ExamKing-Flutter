import 'dart:convert';

import 'package:examKing/global/exception.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/word.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:examKing/global/keys.dart' as keys;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WordService {
  Future<List<Word>> getWords(int level, String testType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse(
        "${dotenv.get('HTTP_HOST')}word?level=$level&test_type=$testType");
    var res = await http.get(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint(
            "backend service | updateUserInfo | get success response ${res.body}");
        return List<Word>.from(json
            .decode(utf8.decode(res.bodyBytes))
            .map((map) => Word.fromMap(map)));
      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint(
            "backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<void> updateWord(Word word) async {
    // TODO: implement updateWord
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}word");
    var res = await http.post(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "word": word.word,
        "status": word.isLearned ? "reviewing" : "learning",
      }),
    );

    switch (res.statusCode) {
      case 200:
        debugPrint(
            "backend service | updateUserInfo | get success response ${res.body}");
      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint(
            "backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }
}
