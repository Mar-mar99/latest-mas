part of 'get_cancellation_bloc.dart';

abstract class GetCancellationState extends Equatable {
  const GetCancellationState();

  @override
  List<Object> get props => [];
}

class GetCancellationInitial extends GetCancellationState {}

class LoadingGetCancellation extends GetCancellationState {}

class LoadedGetCancellation extends GetCancellationState {
  final CancellationEntity data;
  LoadedGetCancellation({

    required this.data,
  });

  @override
  List<Object> get props => [ data];
}

class GetCancellationOfflineState extends GetCancellationState {}

class GetCancellationNetworkErrorState
    extends GetCancellationState {
  final String message;
  const GetCancellationNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
