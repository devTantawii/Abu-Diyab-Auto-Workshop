// lib/features/maintenance/cubit/maintenance_cubit.dart

import 'dart:io';

import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/maintenance_note_model.dart';
import 'maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {

  MaintenanceCubit() : super(MaintenanceInitial());

  /// Helper to format date to yyyy-MM-dd
  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }

  /// Accepts either strings for dates already formatted or DateTimes (optional)
  Future<void> createMaintenance(MaintenanceNote note) async {
    emit(MaintenanceLoading());
    print("=== Maintenance: Loading ==="); // Print initial state

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print("Token: $token");

      // Build FormData
      final map = <String, dynamic>{
        "service_id": note.serviceId,
        "user_car_id": note.userCarId,
        "kilometer": note.kilometer,
        "details": note.details,
      };

      if (note.lastMaintenance != null && note.lastMaintenance!.isNotEmpty) {
        map["last_maintenance"] = note.lastMaintenance;
      }

      if (note.remindMe != null && note.remindMe!.isNotEmpty) {
        map["remind_me"] = note.remindMe;
      }

      if (note.mediaPath != null && note.mediaPath!.isNotEmpty) {
        final file = File(note.mediaPath!);
        if (await file.exists()) {
          map["media"] = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
          print("Media file added: ${file.path}");
        } else {
          print("Media file does not exist: ${file.path}");
        }
      }

      print("FormData to send: $map");

      final formData = FormData.fromMap(map);
      Dio dio = Dio();

      final response = await dio.post(
        "$mainApi/app/elwarsha/user-notes/create",
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );

      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(MaintenanceSuccess(data: response.data));
        print("=== Maintenance: Success ===");
      } else {
        final msg = response.data != null
            ? response.data.toString()
            : "Server returned ${response.statusCode}";
        emit(MaintenanceFailure(msg, statusCode: response.statusCode));
        print("=== Maintenance: Failure === Message: $msg");
      }

    } on DioException catch (dioError) {
      String msg = dioError.message ?? 'Dio error';
      if (dioError.response != null) {
        msg = dioError.response?.data?.toString() ?? dioError.message!;
        emit(MaintenanceFailure(msg, statusCode: dioError.response?.statusCode));
        print("=== DioException Response === Status: ${dioError.response?.statusCode} Message: $msg");
      } else {
        emit(MaintenanceFailure(msg));
        print("=== DioException === Message: $msg");
      }
    } catch (e) {
      emit(MaintenanceFailure(e.toString()));
      print("=== General Exception === $e");
    }
  }
}
