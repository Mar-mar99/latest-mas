// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'log_out_bloc.dart';

abstract class LogOutEvent extends Equatable {
  const LogOutEvent();

  @override
  List<Object> get props => [];
}

class LogOut extends LogOutEvent {
  final TypeAuth typeAuth;
  LogOut({
    required this.typeAuth,
  });
}
