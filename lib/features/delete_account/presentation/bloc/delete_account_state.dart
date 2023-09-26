part of 'delete_account_bloc.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {}

class LoadingDeleteAccount extends DeleteAccountState{}
class DoneDeleteAccount extends DeleteAccountState {

}


class DeleteAccountOfflineState extends DeleteAccountState{}

class DeleteAccountErrorState extends DeleteAccountState {
  final String message;
  const DeleteAccountErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

