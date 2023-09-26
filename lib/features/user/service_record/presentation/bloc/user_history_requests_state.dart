// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_history_requests_bloc.dart';

enum UserPastRequestsStatus { loading,loadingMore, success, offline, error }

class UserHistoryRequestsState extends Equatable {
  final UserPastRequestsStatus status;
  final List<HistoryRequestUserEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;

  const UserHistoryRequestsState(
      {this.status = UserPastRequestsStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,
      this.errorMessage = ""});

  @override
  List<Object> get props =>
      [status, hasReachedMax, pageNumber, data, errorMessage];

  UserHistoryRequestsState copyWith({
    UserPastRequestsStatus? status,
    List<HistoryRequestUserEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return UserHistoryRequestsState(
      status: status ?? this.status,
      data: data ?? this.data,
      pageNumber: pageNumber ?? this.pageNumber,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
