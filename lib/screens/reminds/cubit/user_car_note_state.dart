import '../model/user_car_note_model.dart';

abstract class UserNotesState {}

class UserNotesInitial extends UserNotesState {}

class UserNotesLoading extends UserNotesState {}

class UserNotesLoaded extends UserNotesState {
  final List<UserNote> notes;
  UserNotesLoaded(this.notes);
}

class UserNotesError extends UserNotesState {
  final String message;
  UserNotesError(this.message);
}
