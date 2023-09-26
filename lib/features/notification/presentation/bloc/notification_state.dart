// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';
enum NotificationStatus { loading,loadingMore, success, offline, error }

class NotificationState extends Equatable {
   final NotificationStatus status;
  final List<NotificationEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
  final String errorMessage;


  const NotificationState(
      {this.status = NotificationStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,

      this.errorMessage = ""});


  @override
  List<Object> get props => [
      status ,
      hasReachedMax ,
      data  ,
      pageNumber ,

      errorMessage
  ];

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    String? errorMessage,

  }) {
    return NotificationState(
   status:    status ?? this.status,
    data:   data ?? this.data,
     pageNumber:  pageNumber ?? this.pageNumber,
     hasReachedMax:  hasReachedMax ?? this.hasReachedMax,
     errorMessage:  errorMessage ?? this.errorMessage,

    );
  }
}

