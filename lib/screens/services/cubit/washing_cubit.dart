import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'washing_state.dart';

class WashingCubit extends Cubit<WashingState> {
  WashingCubit() : super(WashingInitial());
}
