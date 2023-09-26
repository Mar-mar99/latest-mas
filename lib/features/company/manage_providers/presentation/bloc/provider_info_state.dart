// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'provider_info_bloc.dart';

abstract class ProviderInfoState extends Equatable {
  const ProviderInfoState();

  @override
  List<Object> get props => [];
}

class ProviderInfoInitial extends ProviderInfoState {}

class LoadingProviderInfo extends ProviderInfoState {}

class LoadedProviderInfo extends ProviderInfoState {
  final ProviderInfoEntity info;
  final List<ProviderEntity> pending;
  LoadedProviderInfo({
    required this.info,
    required this.pending,
  });

  @override
  List<Object> get props => [pending, info];
}

class ProviderInfoOfflineState extends ProviderInfoState {}

class ProviderInfoNetworkErrorState extends ProviderInfoState {
  final String message;
  const ProviderInfoNetworkErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
