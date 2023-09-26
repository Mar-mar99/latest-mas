part of 'remove_service_code_bloc.dart';

abstract class RemoveServiceCodeState extends Equatable {
  const RemoveServiceCodeState();

  @override
  List<Object> get props => [];
}

class RemoveServiceCodeInitial extends RemoveServiceCodeState {}

class LoadingRemoveServiceCode extends RemoveServiceCodeState {}

class LoadedRemoveServiceCode extends RemoveServiceCodeState {
final int serviveId;
  LoadedRemoveServiceCode({
    required this.serviveId,
  });
}

class RemoveServiceCodeOfflineState extends RemoveServiceCodeState {}

class RemoveServiceCodeErrorState extends RemoveServiceCodeState {
  final String message;
  const RemoveServiceCodeErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
