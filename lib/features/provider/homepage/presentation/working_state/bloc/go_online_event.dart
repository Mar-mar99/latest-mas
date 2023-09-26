part of 'go_online_bloc.dart';

@immutable
abstract class GoOnlineEvent {
}


class GetWorkingStatusEvent extends GoOnlineEvent{}
class ChangeOnlineEvent extends GoOnlineEvent{

}
