part of 'get_history_record_provider_bloc.dart';

enum ProviderPastRequestsStatus { loading,loadingMore, success, offline, error }

class GetHistoryRecordProviderState extends Equatable {
  final ProviderPastRequestsStatus status;
  final List<RequestPastProviderEntity> data;
  final int pageNumber;
  final bool hasReachedMax;

  final String errorMessage;

  const GetHistoryRecordProviderState(
      {this.status = ProviderPastRequestsStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,
      this.errorMessage = ""});

  @override
  List<Object> get props => [
        status,
        hasReachedMax,
        pageNumber,
        data,
        errorMessage,
      ];

  GetHistoryRecordProviderState copyWith({
    ProviderPastRequestsStatus? status,
    List<RequestPastProviderEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return GetHistoryRecordProviderState(
      status: status ?? this.status,
      data: data ?? this.data,
      pageNumber: pageNumber ?? this.pageNumber,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
