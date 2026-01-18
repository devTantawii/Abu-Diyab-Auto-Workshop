import 'package:abu_diyab_workshop/screens/services/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/search_repo.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchApi api;

  SearchCubit(this.api) : super(SearchInitial());

  void search(String value) async {
    emit(SearchLoading());
    try {
      final result = await api.search(value);
      emit(SearchSuccess(result));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }void resetSearch() {
    emit(SearchInitial());
  }

}
