part of 'get_saved_location_bloc.dart';

abstract class GetSavedLocationEvent extends Equatable {
  const GetSavedLocationEvent();

  @override
  List<Object> get props => [];
}
class GetLocations extends GetSavedLocationEvent{}
