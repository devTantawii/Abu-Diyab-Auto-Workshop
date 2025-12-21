import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/api.dart';
import '../../../core/langCode.dart';
import '../model/user_car_note_model.dart';

class UserNotesCubit extends Cubit<UserNotesState> {
  UserNotesCubit() : super(UserNotesInitial());

  Future<void> getUserNotes() async {
    emit(UserNotesLoading());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await Dio().get(
        notesGetApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": langCode == '' ? "en" : langCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.data == null || response.data['data'] == null) {
        emit(UserNotesLoaded([]));
        return;
      }

      final data = response.data['data'] as List;

      final notes =
          data.map((e) {
            return UserNote.fromJson(e);
          }).toList();

      emit(UserNotesLoaded(notes));
    } catch (e, stack) {
      emit(UserNotesError(e.toString()));
    }
  }
}
