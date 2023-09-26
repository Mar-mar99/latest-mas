part of 'set_cancellation_bloc.dart';

abstract class SetCancellationState extends Equatable {
  const SetCancellationState();

  @override
  List<Object> get props => [];
}

class SetCancellationInitial extends SetCancellationState {}

class LoadingSetCancellation extends SetCancellationState {}

class LoadedSetCancellation extends SetCancellationState {
 }

class SetCancellationOfflineState extends SetCancellationState {}

class SetCancellationNetworkErrorState
    extends SetCancellationState {
  final String message;
  const SetCancellationNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
