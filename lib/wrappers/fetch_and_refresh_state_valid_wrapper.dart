import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh/fetch_and_refresh_cubit.dart';

/// Assert that the state is valid to render the widget
/// Else will display a button to request a new try
class FetchAndRefreshStateValidWrapper<
    TCubit extends FetchAndRefreshCubit<TState, TIdType, TType>,
    TState extends FetchAndRefreshState<TIdType, TType>,
    TValidState extends FetchAndRefreshWithValueState<TIdType, TType>,
    TIdType,
    TType> extends StatelessWidget {
  /// The id of the fetched element
  /// Check if the id is the correct one
  final TIdType? idToCheck;

  /// Cubit to use, when missing in the context
  final TCubit? cubit;

  /// Builder to render the valid widget
  final Widget Function(BuildContext, TValidState) validRender;

  /// Builder to render the loading widget
  final Widget Function(BuildContext)? loadingRender;

  /// Builder to render the error widget
  final Widget Function(BuildContext)? errorRender;

  /// Set to true if used in a sliver context
  final bool sliver;

  /// Should the retry button be visible
  final bool allowRetry;

  /// Custom retry text if needed
  final String Function(BuildContext)? retryText;

  /// Custom error text if needed
  final String Function(BuildContext)? errorText;

  void retryFunction(BuildContext context, TState localState) {
    if (idToCheck != null) {
      context.read<TCubit>().fetch(idToFetch: idToCheck as TIdType);
    }
  }

  const FetchAndRefreshStateValidWrapper({
    super.key,
    this.idToCheck,
    this.cubit,
    required this.validRender,
    this.loadingRender,
    this.errorRender,
    this.sliver = false,
    this.allowRetry = true,
    this.retryText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCubit, TState>(
      bloc: cubit,
      builder: (BuildContext context, TState localState) {
        if (localState is TValidState && (localState.id == idToCheck || idToCheck == null)) {
          return validRender(context, localState);
        }

        Widget toReturn = Center(
          child: Material(
            color: Colors.transparent,
            child: (localState is FetchAndRefreshFetchingState || localState is FetchAndRefreshInitialState)
                ? loadingRender?.call(context) ??
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: CircularProgressIndicator(),
                    )
                : errorRender?.call(context) ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorText?.call(context) ?? 'An error occurred'),
                        const SizedBox(height: 20),
                        if (allowRetry)
                          ElevatedButton(
                            onPressed: () => (context, localState),
                            child: Text(retryText?.call(context) ?? 'Retry'),
                          ),
                      ],
                    ),
          ),
        );
        if (sliver) {
          return SliverToBoxAdapter(
            child: toReturn,
          );
        }
        return toReturn;
      },
    );
  }
}
