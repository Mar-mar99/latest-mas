// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_provider_bloc.dart';

abstract class AddProviderEvent extends Equatable {
  const AddProviderEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChangedEvent extends AddProviderEvent {
  final String firstName;
  FirstNameChangedEvent({
    required this.firstName,
  });
  @override
  List<Object> get props => [firstName];
}

class LastNameChangedEvent extends AddProviderEvent {
  final String lastName;
  LastNameChangedEvent({
    required this.lastName,
  });
  @override
  List<Object> get props => [lastName];
}

class PhoneChangedEvent extends AddProviderEvent {
  final String phone;
  PhoneChangedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}

class StateChangedEvent extends AddProviderEvent {
  final int state;
  StateChangedEvent({
    required this.state,
  });
  @override
  List<Object> get props => [state];
}

class InviteEvent extends AddProviderEvent {}
