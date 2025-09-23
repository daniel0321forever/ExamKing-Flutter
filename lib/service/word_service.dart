import 'dart:convert';

import 'package:examKing/global/exception.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/level.dart';
import 'package:examKing/models/word.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:examKing/global/keys.dart' as keys;
import 'package:examKing/global/config.dart' as config;
import 'package:flutter/services.dart';

class WordService {
  Future<void> syncWordIsLearnedAndSeenCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(keys.prefTokenKey);
    if (token == null) {
      throw UnAuthenticatedException();
    }

    Uri url = Uri.parse("${dotenv.get('HTTP_HOST')}word_status");
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
            "backend service | syncWordIsLearnedAndSeenCount | get success response ${res.body}");

        List wordStatusList = json.decode(res.body);

        for (Map wordStatus in wordStatusList) {
          prefs.setBool(
              "${keys.prefWordIsLearnedPrefixKey}_${wordStatus[keys.wordWordKey]}",
              wordStatus[keys.wordIsLearnedKey]);
          prefs.setInt(
              "${keys.prefWordSeenCountPrefixKey}_${wordStatus[keys.wordWordKey]}",
              wordStatus[keys.wordSeenCountKey]);
        }
      case 404:
        debugPrint(
            "service | syncWordIsLearnedAndSeenCount | end point not found");
        throw PageNotFoundException();
      case 401:
        debugPrint(
            "backend service | syncWordIsLearnedAndSeenCount | ${res.body}");
        throw UnAuthenticatedException();
      default:
        debugPrint(
            "backend service | syncWordIsLearnedAndSeenCount | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
        throw UnhandledStatusException();
    }
  }

  Future<void> initializeWords({bool force = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int wordVersion = prefs.getInt(keys.prefWordVersionKey) ?? 0;

    if (wordVersion != config.wordVersion || force) {
      // Retrieve words.json from assets
      final String wordsJsonStr =
          await rootBundle.loadString('assets/words.json');

      Map<String, dynamic> wordsJson =
          json.decode(wordsJsonStr) as Map<String, dynamic>;

      for (String testType in wordsJson.keys) {
        if (testType == TestType.hs7000.name) {
          for (String level in wordsJson[testType].keys) {
            for (String book in wordsJson[testType][level].keys) {
              // save word index to share preferences
              prefs.setString(
                "${keys.prefWordIndexPrefixKey}_${testType}_${level}_${book}",
                json.encode(wordsJson[testType][level][book]),
              );
            }
          }
        } else if (testType == TestType.gre.name) {
          for (String level in wordsJson[testType].keys) {
            List levelWords = [];
            for (String book in wordsJson[testType][level].keys) {
              levelWords.addAll(wordsJson[testType][level][book]);
            }
            // save word index to share preferences
            prefs.setString(
              "${keys.prefWordIndexPrefixKey}_${testType}_${level}",
              json.encode(levelWords),
            );
          }
        }
      }

      // sync word isLearned and seenCount from the cloud
      await syncWordIsLearnedAndSeenCount();

      prefs.setInt(keys.prefWordVersionKey, config.wordVersion);
    }
  }

  Future<List<Word>> getWords(Level level) async {
    if (level.testType == TestType.hs7000 && level.book == null) {
      debugPrint(
          "word service | getWords | book should not be null when test type is hs7000");
      throw UnhandledStatusException();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? wordIndex;

    if (level.testType == TestType.hs7000) {
      wordIndex =
          "${keys.prefWordIndexPrefixKey}_${level.testType.name}_${level.level}_${level.book}";
    } else if (level.testType == TestType.gre) {
      wordIndex =
          "${keys.prefWordIndexPrefixKey}_${level.testType.name}_${level.level}";
    } else {
      debugPrint(
          "word service | getWords | test type ${level.testType} not found");
      throw UnhandledStatusException();
    }

    String? wordString = prefs.getString(wordIndex);

    if (wordString == null) {
      debugPrint("word service | getWords | word index $wordIndex not found");
      throw UnhandledStatusException();
    }

    List<Word> words = List<Word>.from(
      json.decode(wordString).map(
        (wordMap) {
          wordMap[keys.wordIsLearnedKey] = prefs.getBool(
                  "${keys.prefWordIsLearnedPrefixKey}_${wordMap[keys.wordWordKey]}") ??
              false;
          wordMap[keys.wordSeenCountKey] = prefs.getInt(
                  "${keys.prefWordSeenCountPrefixKey}_${wordMap[keys.wordWordKey]}") ??
              0;

          return Word.fromMap(wordMap);
        },
      ),
    );

    return words;
  }

  Future<void> updateWord(Word word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    debugPrint(
        "word service | updateWord | pref word is learned (${keys.prefWordIsLearnedPrefixKey}_${word.word})");
    debugPrint(
        "word service | updateWord | pref word seen count (${keys.prefWordSeenCountPrefixKey}_${word.word})");

    prefs.setBool(
        "${keys.prefWordIsLearnedPrefixKey}_${word.word}", word.isLearned);
    prefs.setInt(
        "${keys.prefWordSeenCountPrefixKey}_${word.word}", word.seenCount);

    // also sync the word update to the backend

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
      case 401:
        debugPrint("backend service | updateUserInfo | ${res.body}");
      default:
        debugPrint(
            "backend service | updateUserInfo | error status ${res.statusCode}");
        debugPrint("body ${res.body}");
    }
  }

  Future<double> getHighSchoolWordProgress() async {
    int learnedCount = 0;
    int total = 0;

    // iterate over hs levels and books and find out the total number of words and learned words
    for (int level = 0; level < hsLevels.length; level++) {
      for (int book = 0; book < hsLevels[level].length; book++) {
        List<Word> words = await getWords(hsLevels[level][book]);

        total += words.length;
        for (Word word in words) {
          if (word.isLearned) {
            learnedCount++;
          }
        }
      }
    }

    return (learnedCount / total);
  }

  Future<double> getGREWordProgress() async {
    int learnedCount = 0;
    int total = 0;

    for (int level = 0; level < greLevels.length; level++) {
      List<Word> words = await getWords(greLevels[level]);

      total += words.length;
      for (Word word in words) {
        if (word.isLearned) {
          learnedCount++;
        }
      }
    }

    return (learnedCount / total);
  }
}
