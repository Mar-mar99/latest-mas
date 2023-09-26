// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_state_bloc.dart';

abstract class EditStateEvent extends Equatable {
  const EditStateEvent();

  @override
  List<Object> get props => [];
}
class StateChangedEvent extends EditStateEvent {
  final int state ;
  StateChangedEvent({
    required this.state,
  });
}
class StateUserSubmitEvent extends EditStateEvent {
final String firstName;
final String lastName;
  StateUserSubmitEvent({
    required this.firstName,
    required this.lastName,
  });
}

class StateCompanySubmitEvent extends EditStateEvent {
 final String firstName;
  final String address;
  final int local;
  StateCompanySubmitEvent({
    required this.firstName,
    required this.address,
    required this.local,
  });

}

class StateProviderSubmitEvent extends EditStateEvent {
final String firstName;
final String lastName;
  StateProviderSubmitEvent({
    required this.firstName,
    required this.lastName,
  });
}
