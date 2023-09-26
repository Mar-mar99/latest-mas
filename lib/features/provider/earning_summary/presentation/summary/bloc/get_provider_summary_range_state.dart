part of 'get_provider_summary_range_bloc.dart';

abstract class GetProviderSummaryRangeState extends Equatable {
  const GetProviderSummaryRangeState();

  @override
  List<Object> get props => [];
}

class GetProviderSummaryRangeInitial extends GetProviderSummaryRangeState {}

class LoadingGetProviderSummaryRange extends GetProviderSummaryRangeState {}

class LoadedGetProviderSummaryRange extends GetProviderSummaryRangeState {
  final SummaryEarningsProviderEntity data;
  LoadedGetProviderSummaryRange({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetProviderSummaryRangeOfflineState extends GetProviderSummaryRangeState {}

class GetProviderSummaryRangeErrorState extends GetProviderSummaryRangeState {
  final String message;
  const GetProviderSummaryRangeErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
