part of 'get_provider_summary_today_bloc.dart';

abstract class GetProviderSummaryTodayState extends Equatable {
  const GetProviderSummaryTodayState();

  @override
  List<Object> get props => [];
}

class GetProviderSummaryTodayInitial extends GetProviderSummaryTodayState {}

class LoadingGetProviderSummaryToady extends GetProviderSummaryTodayState {}

class LoadedGetProviderSummaryToady extends GetProviderSummaryTodayState {
  final SummaryEarningsProviderEntity data;
  LoadedGetProviderSummaryToady({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetProviderSummaryToadyOfflineState extends GetProviderSummaryTodayState {}

class GetProviderSummaryToadyErrorState extends GetProviderSummaryTodayState {
  final String message;
  const GetProviderSummaryToadyErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
