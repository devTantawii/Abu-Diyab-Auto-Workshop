// lib/screens/more/cubit/reward_logs_cubit.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/repositorie/profile_repository.dart';
import 'reward_logs_state.dart';

class RewardLogsCubit extends Cubit<RewardLogsState> {
  final ProfileRepository repository;

  RewardLogsCubit(this.repository) : super(RewardLogsInitial());

  Future<void> fetchRewardLogs() async {
    emit(RewardLogsLoading());

    try {
      final response = await repository.getRewardLogs();
      if (response != null) {

        emit(RewardLogsLoaded(response));
      } else {

        emit(const RewardLogsError('لم يتم العثور على بيانات'));
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
      }
      emit(RewardLogsError('فشل في تحميل سجل المكافآت'));
    }
  }

  // دالة لإعادة التحميل (للـ Pull to Refresh)
  Future<void> refresh() => fetchRewardLogs();
}