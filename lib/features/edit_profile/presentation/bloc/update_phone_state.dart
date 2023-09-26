// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_phone_bloc.dart';

abstract class UpdatePhoneState extends Equatable {
@override

  List<Object?> get props => [];
}

class InitUpdatePhoneState extends UpdatePhoneState {}

class LoadingUpdatePhoneState extends UpdatePhoneState {}

class DoneUpdatePhoneState extends UpdatePhoneState {}

class UpdatePhoneOfflineState extends UpdatePhoneState {}

class UpdatePhoneErrorState extends UpdatePhoneState {
  final String message;
  UpdatePhoneErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
