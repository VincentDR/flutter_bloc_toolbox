import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/common/mixins/cubit.dart';
import 'package:meta/meta.dart';

part 'search_text_state.dart';

/// Simple search text cubit
class SearchTextCubit extends Cubit<SearchTextState> with CubitPreventsEmitOnClosed<SearchTextState> {
  SearchTextCubit() : super(const SearchTextInitialState());

  setText(String searchText) {
    emit(SearchTextUpdatedState(searchText: searchText));
  }

  eraseText() {
    emit(const SearchTextUpdatedState());
  }
}
