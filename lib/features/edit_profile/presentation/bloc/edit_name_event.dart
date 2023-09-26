// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_name_bloc.dart';

abstract class EditNameEvent extends Equatable {
  const EditNameEvent();

  @override
  List<Object> get props => [];
}

class SubmitUserNameEvent extends EditNameEvent {
  final String firstName;
  final String lastName;
  final int  state;
  SubmitUserNameEvent({
    required this.firstName,
    required this.lastName,
    required this.state,
  });
}
class SubmitProviderNameEvent extends EditNameEvent {
    final String firstName;
  final String lastName;
  final int  state;
  SubmitProviderNameEvent({
    required this.firstName,
    required this.lastName,
    required this.state,
  });
}
