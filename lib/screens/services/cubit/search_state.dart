import '../model/search_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final SearchResponse data;
  SearchSuccess(this.data);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
