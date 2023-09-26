// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_history_requests_bloc.dart';

abstract class UserHistoryRequestsEvent extends Equatable {
  const UserHistoryRequestsEvent();

  @override
  List<Object> get props => [];
}
class GetUserPastRequestsEvent extends UserHistoryRequestsEvent {
  final bool refresh ;
  GetUserPastRequestsEvent({
     this.refresh=false,
  });
}
