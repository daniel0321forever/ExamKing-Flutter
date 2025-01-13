import 'dart:math';
import 'dart:convert';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/global/keys.dart' as keys;
import 'package:examKing/global/exception.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/stat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AnalysisService {
  AnalysisService();

  Future<List<Stat>> getStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}record");
    var res = await http.get(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updateUserInfo | get success response ${res.body}");
        List<Stat> statList = List<Stat>.from(json.decode(res.body).map((statMap) {
          debugPrint("statMap ${statMap[keys.statKeyKey]}");
          statMap[keys.statTitleKey] = statProperties[statMap[keys.statKeyKey]]![keys.statTitleKey];
          return Stat.fromMap(statMap);
        }));
        return statList;

      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<List<int>> getMonthlyWordProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}word_progress");
    var res = await http.get(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updateUserInfo | get success response ${res.body}");
        return List<int>.from(json.decode(res.body));

      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<List<int>> getPreviousMonthWordProgress(int month, int year) async {
    DateTime previousMonth = DateTime(year, month);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<int> wordProgress = List<int>.generate(daysInMonth, (index) => (index + 1) * (previousMonth.millisecondsSinceEpoch % 100));
    return wordProgress;
  }

  Future<List<List<double>>> getSevenDaysCorrectRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);

    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}correct_rate");
    var res = await http.get(
      url,
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch (res.statusCode) {
      case 200:
        debugPrint("backend service | updateUserInfo | get success response ${res.body}");
        return List<List<double>>.from(json.decode(res.body).map((l) => List<double>.from(l.map((e) => e.toDouble()))));

      case 404:
        debugPrint("service | updateUserInfo | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint("backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }
}
