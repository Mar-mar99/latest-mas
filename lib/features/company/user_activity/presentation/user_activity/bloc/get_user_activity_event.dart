part of 'get_user_activity_bloc.dart';

abstract class GetUserActivityEvent extends Equatable {
  const GetUserActivityEvent();

  @override
  List<Object> get props => [];
}
class GetProvidersActivityEvent extends GetUserActivityEvent {
  final bool refresh ;
  GetProvidersActivityEvent({
     this.refresh=false,
  });
}
