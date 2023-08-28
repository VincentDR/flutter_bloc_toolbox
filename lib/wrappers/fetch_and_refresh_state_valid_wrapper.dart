import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_toolbox/logic/fetch_and_refresh_cubit/fetch_and_refresh_cubit.dart';

/// Assert that the state is valid to render the widget
/// Else will display a button to request a new try
abstract class FetchAndRefreshStateValidWrapper<
    TCubit extends FetchAndRefreshCubit<TState, TIdType, TType>,
    TState extends FetchAndRefreshState<TIdType, TType>,
    TValidState extends FetchAndRefreshWithValueState<TIdType, TType>,
    TIdType,
    TType> extends StatelessWidget {
  final TIdType? idToCheck;
  final Widget Function(BuildContext, TValidState) validRender;
  final Widget Function(BuildContext)? loadingRender;
  final Widget Function(BuildContext)? errorRender;
  final bool sliver;
  final String Function(BuildContext)? retryText;

  String get errorMessage;

  const FetchAndRefreshStateValidWrapper({
    super.key,
    this.idToCheck,
    required this.validRender,
    this.loadingRender,
    this.errorRender,
    this.sliver = false,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCubit, TState>(
      builder: (BuildContext context, TState localState) {
        if (localState is TValidState && (localState.id == idToCheck || idToCheck == null)) {
          return validRender(context, localState);
        }

        Widget toReturn = Center(
          child: Material(
            color: Colors.transparent,
            child: localState is FetchAndRefreshFetchingState
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
                        Text(errorMessage),
                        const SizedBox(height: 20),
                        if (idToCheck != null)
                          ElevatedButton(
                            onPressed: () {
                              context.read<TCubit>().fetch(idToFetch: idToCheck as TIdType);
                            },
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
