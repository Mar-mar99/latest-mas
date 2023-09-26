part of 'get_saved_location_bloc.dart';

abstract class GetSavedLocationState extends Equatable {
  const GetSavedLocationState();

  @override
  List<Object> get props => [];
}

class GetSavedLocationInitial extends GetSavedLocationState {}

class LoadingGetSavedLocation extends GetSavedLocationState {}

class LoadedGetSavedLocation extends GetSavedLocationState {
  final List<MyLocationsEntity> data;
  LoadedGetSavedLocation({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetSavedLocationOfflineState extends GetSavedLocationState {}

class GetSavedLocationErrorState extends GetSavedLocationState {
  final String message;
  const GetSavedLocationErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
