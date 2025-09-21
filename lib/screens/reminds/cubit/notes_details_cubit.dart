// user_note_details_cubit.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abu_diyab_workshop/core/constant/api.dart';

import 'notes_details_state.dart';

class UserNoteDetailsCubit extends Cubit<UserNoteDetailsState> {
  UserNoteDetailsCubit() : super(UserNoteDetailsInitial());

  Future<void> fetchNoteDetails(int noteId) async {
    emit(UserNoteDetailsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print("📡 بجيب بيانات النوت id=$noteId");

      final response = await http.get(
        Uri.parse("$mainApi/app/elwarsha/user-notes/show?user_note_id=$noteId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📩 StatusCode: ${response.statusCode}");
      print("📩 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body)["data"];
        print("✅ البيانات بعد الديكود: $data");
        emit(UserNoteDetailsLoaded(data));
      } else {
        emit(UserNoteDetailsError("خطأ في السيرفر - ${response.statusCode}"));
      }
    } catch (e) {
      print("❌ Exception: $e");
      emit(UserNoteDetailsError(e.toString()));
    }
  }
  Future<void> deleteNote(int noteId) async {
    try {
      emit(UserNoteDetailsLoading());

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse("$mainApi/app/elwarsha/user-notes/delete?user_note_id=$noteId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📩 Delete StatusCode: ${response.statusCode}");
      print("📩 Delete Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(UserNoteDetailsDeleted()); // حالة جديدة خاصة بالحذف
      } else {
        emit(UserNoteDetailsError("فشل حذف النوت ❌"));
      }
    } catch (e) {
      emit(UserNoteDetailsError(e.toString()));
    }
  }

  // lib/screens/reminds/cubit/notes_details_cubit.dart
  Future<void> updateNote({
    required int noteId,
    required String details,
    required String kilometer,
    required String lastMaintenance,
    required String remindMe,
  }) async {
    emit(UserNoteDetailsUpdating()); // 👈 حالة جديدة أثناء التحديث

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse("$mainApi/app/elwarsha/user-notes/update"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "user_note_id": noteId.toString(),
          "details": details,
          "kilometer": kilometer,
          "last_maintenance": lastMaintenance,
          "remind_me": remindMe,
        },
      );

      print("📩 Update StatusCode: ${response.statusCode}");
      print("📩 Update Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body)["data"];
        emit(UserNoteDetailsUpdated(note: data));
      } else {
        emit(UserNoteDetailsError("فشل تحديث البيانات"));
      }
    } catch (e) {
      emit(UserNoteDetailsError(e.toString()));
    }
  }


}
