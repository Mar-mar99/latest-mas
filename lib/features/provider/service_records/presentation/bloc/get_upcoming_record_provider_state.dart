part of 'get_upcoming_record_provider_bloc.dart';
enum ProviderUpcomingRequestsStatus { loading,loadingMore, success, offline, error }

 class GetUpcomingRecordProviderState extends Equatable {
 final ProviderUpcomingRequestsStatus status;
  final List<RequestUpcomingProviderEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;

  const GetUpcomingRecordProviderState(
      {this.status = ProviderUpcomingRequestsStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,
      this.errorMessage = ""});

  @override
  List<Object> get props =>
      [status, hasReachedMax, pageNumber, data, errorMessage];




  GetUpcomingRecordProviderState copyWith({
    ProviderUpcomingRequestsStatus? status,
    List<RequestUpcomingProviderEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return GetUpcomingRecordProviderState(
   status:    status ?? this.status,
     data:  data ?? this.data,
    pageNumber:   pageNumber ?? this.pageNumber,
    hasReachedMax:   hasReachedMax ?? this.hasReachedMax,
   errorMessage:    errorMessage ?? this.errorMessage,
    );
  }
}

