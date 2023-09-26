// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_upcoming_requests_bloc.dart';

abstract class UserUpcomingRequestsEvent extends Equatable {
  const UserUpcomingRequestsEvent();

  @override
  List<Object> get props => [];
}
class GetUserUpcomingtRequestsEvent extends UserUpcomingRequestsEvent {
   final bool refresh;
  GetUserUpcomingtRequestsEvent({
     this.refresh=false,
  });
}
