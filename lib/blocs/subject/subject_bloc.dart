import 'package:bloc/bloc.dart';
import 'package:examKing/models/subject.dart';
import 'package:examKing/service/word_service.dart';
import 'package:examKing/global/properties.dart';
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
        } else if (subject.key == "7000") {
          subject.progress = await wordService.getHighSchoolWordProgress();
        }
      }

      emit(SubjectStateInitialDataLoaded());
    });
  }
}
