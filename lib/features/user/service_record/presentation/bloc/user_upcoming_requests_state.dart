// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_upcoming_requests_bloc.dart';
enum UserUpcomingRequestsStatus { loading,loadingMore, success, offline, error }

class UserUpcomingRequestsState extends Equatable {
  final UserUpcomingRequestsStatus status;
  final List<UpcomingRequestUserEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;

  const UserUpcomingRequestsState(
      {this.status = UserUpcomingRequestsStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,
      this.errorMessage = ""});

  @override
  List<Object> get props =>
      [status, hasReachedMax, pageNumber, data, errorMessage];




  UserUpcomingRequestsState copyWith({
    UserUpcomingRequestsStatus? status,
    List<UpcomingRequestUserEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return UserUpcomingRequestsState(
   status:    status ?? this.status,
     data:  data ?? this.data,
    pageNumber:   pageNumber ?? this.pageNumber,
    hasReachedMax:   hasReachedMax ?? this.hasReachedMax,
   errorMessage:    errorMessage ?? this.errorMessage,
    );
  }
}

