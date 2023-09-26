// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'save_location_bloc.dart';

abstract class SaveLocationEvent extends Equatable {
  const SaveLocationEvent();

  @override
  List<Object> get props => [];
}
class SaveLocation extends SaveLocationEvent {
  final MyLocationsModel myLocationsModel;
  SaveLocation({
    required this.myLocationsModel,
  });
}
