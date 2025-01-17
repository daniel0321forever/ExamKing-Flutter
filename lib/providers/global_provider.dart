import 'package:flutter/material.dart';
import 'package:examKing/models/user.dart';

class GlobalProvider extends ChangeNotifier {
  UserData? userData;
  List<int>? wordProgress;
  List<List<double>>? correctRates;

  void setWordProgress(List<int> wordProgress) {
    this.wordProgress = wordProgress;
    notifyListeners();
  }

  void pushProgress() {
    if (wordProgress != null && wordProgress!.isNotEmpty) {
      wordProgress![wordProgress!.length - 1]++;
    }
    notifyListeners();
  }

  void setCorrectRates(List<List<double>> correctRates) {
    this.correctRates = correctRates;
    notifyListeners();
  }
}
