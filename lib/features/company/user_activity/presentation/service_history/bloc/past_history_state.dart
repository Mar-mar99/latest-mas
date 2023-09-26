// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'past_history_bloc.dart';

enum PastRequestsStatus { loadingFirstTime, loading, success, offline, error }

class PastHistoryState extends Equatable {
  final PastRequestsStatus status;
  final List<ServiceHistoryEntity> data;
  final List<CompanyProviderEntity> providers;
  final DateTime from;
  final DateTime to;
  final String providerId;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;

  PastHistoryState(
      {this.status = PastRequestsStatus.loadingFirstTime,
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

  PastHistoryState copyWith({
    PastRequestsStatus? status,
    List<ServiceHistoryEntity>? data,
    List<CompanyProviderEntity>? providers,
    String? providerId,
    DateTime? from,
    DateTime? to,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PastHistoryState(
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
