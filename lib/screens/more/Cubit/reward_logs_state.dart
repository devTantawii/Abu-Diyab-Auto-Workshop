  // lib/screens/more/cubit/reward_logs_state.dart
  import 'package:equatable/equatable.dart';
  import '../model/reward_log_model.dart';

  abstract class RewardLogsState extends Equatable {
    const RewardLogsState();

    @override
    List<Object> get props => [];
  }

  // الحالة الابتدائية
  class RewardLogsInitial extends RewardLogsState {
    const RewardLogsInitial();
  }

  // حالة التحميل
  class RewardLogsLoading extends RewardLogsState {
    const RewardLogsLoading();
  }

  // حالة نجاح التحميل
  class RewardLogsLoaded extends RewardLogsState {
    final RewardLogsResponse data;

    const RewardLogsLoaded(this.data);

    @override
    List<Object> get props => [data];
  }

  // حالة فشل التحميل
  class RewardLogsError extends RewardLogsState {
    final String message;

    const RewardLogsError(this.message);

    @override
    List<Object> get props => [message];
  }