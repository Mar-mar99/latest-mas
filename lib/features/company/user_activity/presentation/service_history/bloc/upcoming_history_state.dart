part of 'upcoming_history_bloc.dart';
enum UpcomingRequestsStatus { loadingFirstTime, loading, success, offline, error }

 class UpcomingHistoryState extends Equatable {
   final UpcomingRequestsStatus status;
  final List<ServiceHistoryEntity> data;
  final List<CompanyProviderEntity> providers;
  final DateTime from;
  final DateTime to;
  final String providerId;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;

  UpcomingHistoryState(
      {this.status = UpcomingRequestsStatus.loadingFirstTime,
      this.hasReachedMax = false,
      this.data = const [],
      this.providers = const[],
      this.providerId = "",
      this.pageNumber = 1,
      this.errorMessage = "",
      required this.from,
      required this.to});

  @override
  List<Object> get props => [
        status,
        hasReachedMax,
        pageNumber,
        providers,
        data,
        from,
        to,
        providerId,
        errorMessage,
      ];

  UpcomingHistoryState copyWith({
    UpcomingRequestsStatus? status,
    List<ServiceHistoryEntity>? data,
    List<CompanyProviderEntity>? providers,
    String? providerId,
    DateTime? from,
    DateTime? to,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return UpcomingHistoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      providers: providers ?? this.providers,
      providerId: providerId ?? this.providerId,
      pageNumber: pageNumber ?? this.pageNumber,
      from: from ?? this.from,
      to: to ?? this.to,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
 }
