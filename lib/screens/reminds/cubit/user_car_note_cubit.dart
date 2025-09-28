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
      print("📢 [UserNotesCubit] Fetching notes from API...");
      print(" 📢📢📢📢📢📢📢📢 $token");

      final response = await Dio().get(
        "$mainApi/app/elwarsha/user-notes/get",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": langCode == '' ? "en" : langCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("✅ [UserNotesCubit] API response status: ${response.statusCode}");
      print("✅ [UserNotesCubit] Full response: ${response.data}");

      if (response.data == null || response.data['data'] == null) {
        print("⚠️ [UserNotesCubit] No data field found in response");
        emit(UserNotesLoaded([]));
        return;
      }

      final data = response.data['data'] as List;
      print("📊 [UserNotesCubit] Data length: ${data.length}");

      final notes =
          data.map((e) {
            print("📝 [UserNotesCubit] Parsing note: $e");
            return UserNote.fromJson(e);
          }).toList();

      print(
        "🎯 [UserNotesCubit] Notes parsed successfully, count: ${notes.length}",
      );

      emit(UserNotesLoaded(notes));
    } catch (e, stack) {
      print("❌ [UserNotesCubit] Error: $e");
      print("❌ [UserNotesCubit] Stack: $stack");
      emit(UserNotesError(e.toString()));
    }
  }
}
