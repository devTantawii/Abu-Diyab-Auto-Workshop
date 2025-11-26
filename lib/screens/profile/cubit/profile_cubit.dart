import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_model.dart';
import '../repositorie/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    print('📡 [fetchProfile] بدأ جلب بيانات المستخدم...');
    emit(ProfileLoading());

    try {
      final user = await repository.getUserProfile();
      print('✅ [fetchProfile] تم استرجاع بيانات المستخدم: $user');

      if (user != null) {
        emit(ProfileLoaded(user));
        print('🎯 [fetchProfile] تم إرسال الحالة: ProfileLoaded');
      } else {
        print('⚠️ [fetchProfile] لم يتم العثور على بيانات المستخدم');
        emit(ProfileError('لم يتم العثور على البيانات'));
      }
    } catch (e, stack) {
      print('❌ [fetchProfile] حدث خطأ أثناء الجلب: $e');
      if (kDebugMode) {
        print(stack);
      }
      emit(ProfileError(e.toString()));
    }
  }
  Future<void> deleteAccount() async {
    print("🔥 deleteAccount() in cubit CALLED");

    emit(ProfileLoading());

    try {
      final success = await repository.deleteAccount();
      if (success) {
        emit(ProfileDeleted());
      } else {
        emit(ProfileError("Failed to delete account"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    File? imageFile,
  }) async {
    print('🛠️ [updateProfile] بدء تحديث الملف الشخصي...');
    print('🧾 البيانات: id=$id, firstName=$firstName, lastName=$lastName, phone=$phone');
    if (imageFile != null) {
      print('🖼️ تم اختيار صورة: ${imageFile.path}');
    }

    final currentState = state;
    if (currentState is ProfileLoaded) {
      print('🔄 [updateProfile] الحالة الحالية ProfileLoaded → سيتم التحديث...');
      emit(ProfileUpdating(currentState.user));
    }

    try {
      final updatedUser = await repository.updateUserProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        imageFile: imageFile,
      );

      if (updatedUser != null) {
        print('✅ [updateProfile] تم تحديث البيانات بنجاح: $updatedUser');
        emit(ProfileUpdated(updatedUser));
        emit(ProfileLoaded(updatedUser));
        print('🎯 [updateProfile] تم إرسال الحالة: ProfileLoaded بعد التحديث');
      } else {
        print('⚠️ [updateProfile] فشل تحديث البيانات – returned null');
        emit(ProfileError('فشل تحديث البيانات'));
      }
    } catch (e, stack) {
      print('❌ [updateProfile] حدث خطأ أثناء التحديث: $e');
      if (kDebugMode) {
        print(stack);
      }
      emit(ProfileError(e.toString()));
    }
  }
}
