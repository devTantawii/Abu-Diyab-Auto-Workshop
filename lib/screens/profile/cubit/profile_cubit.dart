import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../repositorie/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  /// 🔹 جلب بيانات البروفايل
  void fetchProfile() async {
    emit(ProfileLoading());
    try {
      final user = await repository.getUserProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('لم يتم العثور على البيانات'));
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error in fetchProfile: $e");
      debugPrint("📌 StackTrace: $stackTrace");
      emit(ProfileError('فشل تحميل البيانات: $e'));
    }
  }

  /// 🔹 تحديث بيانات البروفايل
  void updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    File? imageFile,
  }) async {
    try {
      debugPrint("🔹 Start updateProfile for user id: $id");
      final currentState = state;
      if (currentState is ProfileLoaded) {
        debugPrint("🔹 Current state is ProfileLoaded: ${currentState.user}");
        emit(ProfileUpdating(currentState.user));
        debugPrint("🔹 Emitted ProfileUpdating state");
      } else {
        debugPrint("⚠️ Current state is NOT ProfileLoaded: $currentState");
      }

      debugPrint("🔹 Calling repository.updateUserProfile...");
      final updatedUser = await repository.updateUserProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        imageFile: imageFile,
      );
      debugPrint("🔹 repository.updateUserProfile returned: $updatedUser");

      if (updatedUser != null) {
        debugPrint("🔹 Saving updated user to SharedPreferences...");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', updatedUser.name);
        debugPrint("🔹 Saved username: ${updatedUser.name}");
        if (updatedUser.image != null) {
          await prefs.setString('profile_image', updatedUser.image!);
          debugPrint("🔹 Saved profile image: ${updatedUser.image}");
        }

        emit(ProfileUpdated(updatedUser));
        debugPrint("🔹 Emitted ProfileUpdated state");

        emit(ProfileLoaded(updatedUser));
        debugPrint("🔹 Emitted ProfileLoaded state");
      } else {
        debugPrint("❌ Updated user is null");
        emit(ProfileError('فشل تحديث البيانات'));
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error in updateProfile: $e");
      debugPrint("📌 StackTrace: $stackTrace");
      emit(ProfileError('فشل تحديث البيانات: $e'));
    }
  }

}
