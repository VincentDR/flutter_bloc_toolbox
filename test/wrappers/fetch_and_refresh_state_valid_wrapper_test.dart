import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/flutter_bloc_toolbox.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/cubits/fetch_and_refresh_cubit/mock_fetch_and_refresh_cubit.dart';
import '../mocks/fixtures/person_entity_fixture.dart';
import '../mocks/repositories/mock_repository.dart';
import '../mocks/testable_widget.dart';
import '../mocks/wrappers/mock_fetch_and_refresh_state_valid_wrapper.dart';

void main() {
  group('FetchAndRefreshStateValidWrapper test', () {
    String idToGet = 'idToGet';
    MockRepository<PersonEntity> personRepository = MocktailRepository<PersonEntity>();

    testWidgets('FetchAndRefreshStateValidWrapper test valid state', (WidgetTester tester) async {
      final MockFetchAndRefreshCubit mockFetchAndRefreshCubit = MockFetchAndRefreshCubit(personRepository);
      when(() => personRepository.getObject(idToGet))
          .thenAnswer((_) async => PersonEntityFixture.factory(idToGet).makeSingle());

      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<MockFetchAndRefreshCubit>.value(
            value: mockFetchAndRefreshCubit,
            child: MockFetchAndRefreshStateValidWrapper(
              validRender: (BuildContext context, MockFetchAndRefreshWithValueState validState) {
                return const ColoredBox(
                  color: Colors.green,
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await mockFetchAndRefreshCubit.fetch(idToFetch: idToGet);
      expect(mockFetchAndRefreshCubit.state, isA<FetchAndRefreshSuccessState>());
      await tester.pump();
      expect(find.byType(ColoredBox), findsOneWidget);

      await mockFetchAndRefreshCubit.refresh();
      expect(mockFetchAndRefreshCubit.state, isA<FetchAndRefreshRefreshingSuccessState>());
      await tester.pump();
      expect(find.byType(ColoredBox), findsOneWidget);

      mockFetchAndRefreshCubit.reset();
      expect(mockFetchAndRefreshCubit.state, isA<FetchAndRefreshInitialState>());
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      mockFetchAndRefreshCubit.close();
    });

    testWidgets('FetchAndRefreshStateValidWrapper test invalid state', (WidgetTester tester) async {
      final MockFetchAndRefreshCubit mockFetchAndRefreshCubit = MockFetchAndRefreshCubit(personRepository);
      when(() => personRepository.getObject(idToGet)).thenAnswer((_) async => null);

      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<MockFetchAndRefreshCubit>.value(
            value: mockFetchAndRefreshCubit,
            child: MockFetchAndRefreshStateValidWrapper(
              validRender: (BuildContext context, MockFetchAndRefreshWithValueState validState) {
                return const ColoredBox(
                  color: Colors.green,
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await mockFetchAndRefreshCubit.fetch(idToFetch: idToGet);
      expect(mockFetchAndRefreshCubit.state, isA<FetchAndRefreshFetchingErrorState>());
      await tester.pump();
      expect(find.byType(Text), findsOneWidget);

      await mockFetchAndRefreshCubit.refresh();
      expect(mockFetchAndRefreshCubit.state, isA<FetchAndRefreshFetchingErrorState>());
      await tester.pump();
      expect(find.byType(Text), findsOneWidget);

      mockFetchAndRefreshCubit.close();
    });
  });
}
