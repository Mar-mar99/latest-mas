part of 'add_update_delete_bloc.dart';

abstract class AddUpdateDeleteState extends Equatable {
  const AddUpdateDeleteState();

  @override
  List<Object> get props => [];
}

class AddUpdateDeleteInitial extends AddUpdateDeleteState {}

class LoadingAddUpdateDeleteState extends AddUpdateDeleteState {}

class DoneAddUpdateDeleteState extends AddUpdateDeleteState {}

class AddUpdateDeleteOfflineState extends AddUpdateDeleteState {}

class AddUpdateDeleteErrorState extends AddUpdateDeleteState {
  final String message;
  const AddUpdateDeleteErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
