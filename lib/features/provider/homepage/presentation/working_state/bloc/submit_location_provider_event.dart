part of 'submit_location_provider_bloc.dart';

abstract class SubmitLocationProviderEvent extends Equatable {
  const SubmitLocationProviderEvent();

  @override
  List<Object> get props => [];
}
class StartSubmittingLocation extends SubmitLocationProviderEvent{

}
class StopSubmittingLocation extends SubmitLocationProviderEvent{}
