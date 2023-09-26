part of 'delete_card_bloc.dart';

abstract class DeleteCardState extends Equatable {
  const DeleteCardState();

  @override
  List<Object> get props => [];
}

class DeleteCardInitial extends DeleteCardState {}

class LoadingDeleteCard extends DeleteCardState {}

class DoneDeleteCard extends DeleteCardState {

}

class DeleteCardOfflineState extends DeleteCardState {}

class DeleteCardErrorState extends DeleteCardState {
  final String message;
  const DeleteCardErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
