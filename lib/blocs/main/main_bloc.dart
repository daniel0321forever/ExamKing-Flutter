import 'package:bloc/bloc.dart';
import 'package:examKing/models/ability_record.dart';
import 'package:examKing/service/backend.dart';
import 'package:examKing/providers/user_provider.dart';
import 'package:flutter/material.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final UserProvider userProvider;

  BackendService backendService = BackendService();
  List<AbilityRecord>? abilityRecords;

  MainBloc({required this.userProvider}) : super(MainInitial()) {
    on<MainEventGetRecord>((event, emit) async {
      try {
        debugPrint("on MainEventGetRecord | triggered");
        abilityRecords = await backendService.getAbilityRecord();

        debugPrint("on MainEventGetRecord | emitting MainStateGetRecord");
        emit(MainStateGetRecords());
      } on Exception catch (e) {
        emit(MainStateError(exception: e));
        debugPrint("on MainEventGetRecord | Unexcepted exception occurs: $e");
      }
    });

    on<MainEventUpdateUserName>((event, emit) async {
      try {
        debugPrint("on MainEventUpdateUserName | triggered with name: ${event.name}");
        userProvider.userData!.name = event.name;
        await backendService.updateUserInfo({"name": event.name});

        debugPrint("on MainEventUpdateUserName | emitting MainStateUpdateUserName");
        emit(MainStateUpdateUserName());
      } on Exception catch (e) {
        emit(MainStateError(exception: e));
        debugPrint("on MainEventUpdateUserName | Unexcepted exception occurs: $e");
      }
    });
  }
}
