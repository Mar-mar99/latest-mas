part of 'rate_provider_bloc.dart';

abstract class RateProviderState extends Equatable {
  const RateProviderState();

  @override
  List<Object> get props => [];
}


class RateProviderInitial extends RateProviderState {}

class LoadingRateProvider extends RateProviderState {}

class LoadedRateProvider extends RateProviderState {}

class RateProviderOfflineState extends RateProviderState {}

class RateProviderErrorState extends RateProviderState {
  final String message;
  const RateProviderErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
