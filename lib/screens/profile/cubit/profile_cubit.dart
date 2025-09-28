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
    emit(ProfileLoading());
    try {
      final user = await repository.getUserProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('لم يتم العثور على البيانات'));
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
    final currentState = state;
    if (currentState is ProfileLoaded) {
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
        emit(ProfileUpdated(updatedUser));
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileError('فشل تحديث البيانات'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
