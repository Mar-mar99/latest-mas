part of 'save_location_bloc.dart';

abstract class SaveLocationState extends Equatable {
  const SaveLocationState();

  @override
  List<Object> get props => [];
}

class SaveLocationInitial extends SaveLocationState {}

class LoadingSaveLocation extends SaveLocationState {}

class LoadedSaveLocation extends SaveLocationState {
 
}

class SaveLocationOfflineState extends SaveLocationState {}

class SaveLocationErrorState extends SaveLocationState {
  final String message;
  const SaveLocationErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
