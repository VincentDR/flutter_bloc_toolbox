part of 'search_text_cubit.dart';

@immutable
abstract class SearchTextState extends Equatable {
  final String searchText;

  const SearchTextState({this.searchText = ''});

  @override
  List<Object?> get props => [searchText];
}

class SearchTextInitialState extends SearchTextState {
  const SearchTextInitialState({super.searchText});
}

class SearchTextUpdatedState extends SearchTextState {
  const SearchTextUpdatedState({super.searchText});
}
