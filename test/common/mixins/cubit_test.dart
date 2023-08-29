import 'package:flutter_bloc_toolbox/logic/search_text/search_text_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Cubit mixin', () {
    SearchTextCubit searchTextCubit = SearchTextCubit();
    String searchText = 'test';

    test('Does not emit state when close nor throw error', () {
      expect(searchTextCubit.state.searchText, '');
      searchTextCubit.setText(searchText);
      expect(searchTextCubit.state.searchText, searchText);
      searchTextCubit.close();
      searchTextCubit.eraseText();
      expect(searchTextCubit.state.searchText, searchText);
    });
  });
}
