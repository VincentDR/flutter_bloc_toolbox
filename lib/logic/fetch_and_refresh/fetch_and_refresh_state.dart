part of 'fetch_and_refresh_cubit.dart';

@immutable
abstract class FetchAndRefreshState<TIdType, TType> {
  const FetchAndRefreshState();
}

abstract class FetchAndRefreshWithIdState<TIdType, TType> extends FetchAndRefreshState<TIdType, TType> {
  final TIdType id;

  const FetchAndRefreshWithIdState({required this.id}) : super();
}

abstract class FetchAndRefreshWithValueState<TIdType, TType> extends FetchAndRefreshWithIdState<TIdType, TType> {
  final TType object;

  const FetchAndRefreshWithValueState({
    required super.id,
    required this.object,
  }) : super();
}

interface class FetchAndRefreshLoadingState {}

interface class FetchAndRefreshSuccessState {}

interface class FetchAndRefreshErrorState {}

class FetchAndRefreshInitialState<TIdType, TType> extends FetchAndRefreshState<TIdType, TType> {}

class FetchAndRefreshFetchingState<TIdType, TType> extends FetchAndRefreshWithIdState<TIdType, TType>
    implements FetchAndRefreshLoadingState {
  const FetchAndRefreshFetchingState({required super.id}) : super();
}

class FetchAndRefreshFetchingSuccessState<TIdType, TType> extends FetchAndRefreshWithValueState<TIdType, TType>
    implements FetchAndRefreshSuccessState {
  const FetchAndRefreshFetchingSuccessState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshFetchingErrorState<TIdType, TType> extends FetchAndRefreshWithIdState<TIdType, TType>
    implements FetchAndRefreshErrorState {
  const FetchAndRefreshFetchingErrorState({required super.id}) : super();
}

class FetchAndRefreshRefreshingState<TIdType, TType> extends FetchAndRefreshWithValueState<TIdType, TType>
    implements FetchAndRefreshLoadingState {
  const FetchAndRefreshRefreshingState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshRefreshingSuccessState<TIdType, TType> extends FetchAndRefreshWithValueState<TIdType, TType>
    implements FetchAndRefreshSuccessState {
  const FetchAndRefreshRefreshingSuccessState({
    required super.id,
    required super.object,
  }) : super();
}

class FetchAndRefreshRefreshingErrorState<TIdType, TType> extends FetchAndRefreshWithValueState<TIdType, TType>
    implements FetchAndRefreshErrorState {
  const FetchAndRefreshRefreshingErrorState({
    required super.id,
    required super.object,
  }) : super();
}
