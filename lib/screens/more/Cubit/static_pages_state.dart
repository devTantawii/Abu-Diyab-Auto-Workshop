part of 'static_pages_cubit.dart';


abstract class StaticPagesState {}

class StaticPagesInitial extends StaticPagesState {}

class StaticPagesLoading extends StaticPagesState {}

class StaticPagesLoaded extends StaticPagesState {
  final StaticPagesModel pages;
  StaticPagesLoaded(this.pages);
}

class StaticPagesError extends StaticPagesState {
  final String message;
  StaticPagesError(this.message);
}