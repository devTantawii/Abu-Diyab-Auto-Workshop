// user_note_details_state.dart

abstract class UserNoteDetailsState {
  @override
  List<Object?> get props => [];
}
// lib/screens/reminds/cubit/notes_details_state.dart
class UserNoteDetailsUpdating extends UserNoteDetailsState {}
class UserNoteDetailsDeleted extends UserNoteDetailsState {}

class UserNoteDetailsUpdated extends UserNoteDetailsState {
  final Map<String, dynamic> note;
  UserNoteDetailsUpdated({required this.note});
}

class UserNoteDetailsInitial extends UserNoteDetailsState {}

class UserNoteDetailsLoading extends UserNoteDetailsState {}

class UserNoteDetailsLoaded extends UserNoteDetailsState {
  final Map<String, dynamic> note;

  UserNoteDetailsLoaded(this.note);

  @override
  List<Object?> get props => [note];
}

class UserNoteDetailsError extends UserNoteDetailsState {
  final String message;

  UserNoteDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
