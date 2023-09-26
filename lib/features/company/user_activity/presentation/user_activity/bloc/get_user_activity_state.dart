// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_user_activity_bloc.dart';

enum GetUserActivityStatus { loading, success, offline, error }

class GetUserActivityState extends Equatable {
  final GetUserActivityStatus status;
  final List<UserActivityEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;
  final int total;

  const GetUserActivityState({
    required this.status,
    required this.data,
    required this.pageNumber,
    required this.hasReachedMax,
    required this.errorMessage,
    required this.total,
  });
  factory GetUserActivityState.empty() {
    return const GetUserActivityState(
        status: GetUserActivityStatus.loading,
        data: [],
        pageNumber: 1,
        hasReachedMax: false,
        errorMessage: '',
        total: 0);
  }
  @override
  List<Object> get props =>
      [status, hasReachedMax, pageNumber, data, errorMessage,total];



  GetUserActivityState copyWith({
    GetUserActivityStatus? status,
    List<UserActivityEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
    int? total,
  }) {
    return GetUserActivityState(
      status: status ?? this.status,
      data: data ?? this.data,
      pageNumber: pageNumber ?? this.pageNumber,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      total: total ?? this.total,
    );
  }
}
