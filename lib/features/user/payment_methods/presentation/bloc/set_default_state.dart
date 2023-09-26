part of 'set_default_bloc.dart';

abstract class SetDefaultState extends Equatable {
  const SetDefaultState();

  @override
  List<Object> get props => [];
}

class SetDefaultInitial extends SetDefaultState {}

class LoadingSetDefault extends SetDefaultState {}

class DoneSetDefault extends SetDefaultState {

}

class SetDefaultOfflineState extends SetDefaultState {}

class SetDefaultErrorState extends SetDefaultState {
  final String message;
  const SetDefaultErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
