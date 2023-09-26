// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_phone_bloc.dart';

abstract class UpdatePhoneEvent extends Equatable {
  const UpdatePhoneEvent();

  @override
  List<Object> get props => [];
}


class UserPhoneSubmitEvent extends UpdatePhoneEvent {
  final TypeAuth typeAuth;
  final String phone;
  UserPhoneSubmitEvent({
    required this.typeAuth,
    required this.phone,
  });
}
