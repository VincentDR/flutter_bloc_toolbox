import 'package:example/data/person_repository.dart';
import 'package:example/logic/fetch_and_refresh_paginated/persons_fetch_and_refresh_paginated_cubit.dart';
import 'package:example/logic/filter_enum/filter_enum_cubit.dart';
import 'package:example/logic/sort_enum/sort_enum_cubit.dart';
import 'package:example/presentation/persons_fetch_and_refresh_state_valid_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_toolbox/logic/bool/bool_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String idToFetch = 'idToFetch';
  final PersonsFetchAndRefreshPaginatedCubit paginatedCubit = PersonsFetchAndRefreshPaginatedCubit(
    PersonRepository(),
    BoolCubit(),
    FilterEnumCubitExample((p0) => false),
    SortEnumCubitExample(),
  );

  @override
  void initState() {
    super.initState();
    paginatedCubit.fetch(idToFetch: idToFetch);
  }

  @override
  void dispose() {
    paginatedCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Example'),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            PersonsFetchAndRefreshStateValidWrapper(
              cubit: paginatedCubit,
              validRender: (BuildContext context, PersonsFetchAndRefreshPaginatedWithValueState localState) {
                return SliverList.builder(
                  itemCount: localState.persons.data.length,
                  itemBuilder: (BuildContext context, int i) => Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                        '${localState.persons.data.elementAt(i).firstName} ${localState.persons.data.elementAt(i).lastName}'),
                  ),
                );
              },
            ),
            PersonsFetchAndRefreshStateValidWrapper(
              cubit: paginatedCubit,
              validRender: (BuildContext context, PersonsFetchAndRefreshPaginatedWithValueState localState) {
                return SliverToBoxAdapter(
                  child: TextButton(
                    onPressed: () => paginatedCubit.fetch(
                      idToFetch: idToFetch,
                      loadMore: true,
                    ),
                    child: const Text('More'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
