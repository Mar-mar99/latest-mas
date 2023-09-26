part of 'rate_request_bloc.dart';

abstract class RateRequestState extends Equatable {
  const RateRequestState();

  @override
  List<Object> get props => [];
}

class RateRequestInitial extends RateRequestState {}

class LoadingRateRequest extends RateRequestState {}

class LoadedRateRequest extends RateRequestState {}

class RateRequestOfflineState extends RateRequestState {}

class RateRequestErrorState extends RateRequestState {
  final String message;
  const RateRequestErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
