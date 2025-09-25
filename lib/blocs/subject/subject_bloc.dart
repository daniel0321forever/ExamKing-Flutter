import 'package:bloc/bloc.dart';
import 'package:examKing/models/subject.dart';
import 'package:examKing/service/word_service.dart';
import 'package:examKing/global/properties.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final WordService wordService = WordService();

  SubjectBloc() : super(SubjectInitial()) {
    on<SubjectEventGetSubjectInitialData>((event, emit) async {
      for (Subject subject in subjects) {
        if (subject.key == "gre") {
          subject.progress = await wordService.getGREWordProgress();
          debugPrint("GRE progress: ${subject.progress}");
        } else if (subject.key == "hs7000") {
          subject.progress = await wordService.getHighSchoolWordProgress();
          debugPrint("hs7000 progress: ${subject.progress}");
        }
      }

      emit(SubjectStateInitialDataLoaded());
    });
  }
}
