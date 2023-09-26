part of 'delete_location_bloc.dart';

abstract class DeleteLocationState extends Equatable {
  const DeleteLocationState();

  @override
  List<Object> get props => [];
}

class DeleteLocationInitial extends DeleteLocationState {}

class LoadingDeleteLocation extends DeleteLocationState {}

class LoadedDeleteLocation extends DeleteLocationState {

}

class DeleteLocationOfflineState extends DeleteLocationState {}

class DeleteLocationErrorState extends DeleteLocationState {
  final String message;
  const DeleteLocationErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
