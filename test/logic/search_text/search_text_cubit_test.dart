import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_toolbox/logic/search_text/search_text_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchTextCubit with correct state', () {
    String textToSearch = 'TextToSearch';
    blocTest<SearchTextCubit, SearchTextState>(
      'Search initial',
      build: () => SearchTextCubit(),
      expect: () => [],
    );

    blocTest<SearchTextCubit, SearchTextState>(
      'Search initial and change value',
      build: () => SearchTextCubit(),
      act: (cubit) => cubit.setText(textToSearch),
      expect: () => [
        isA<SearchTextState>().having((a) => a.searchText, 'Change state', textToSearch),
      ],
    );

    blocTest<SearchTextCubit, SearchTextState>(
      'Search initial and change value then erase',
      build: () => SearchTextCubit(),
      act: (cubit) {
        cubit.setText(textToSearch);
        cubit.eraseText();
      },
      expect: () => [
        isA<SearchTextState>().having((a) => a.searchText, 'Change state', textToSearch),
        isA<SearchTextState>().having((a) => a.searchText, 'Change state', ''),
      ],
    );
  });
}
