// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'request_details_bloc.dart';

abstract class RequestDetailsState extends Equatable {
  const RequestDetailsState();

  @override
  List<Object> get props => [];
}

 class RequestDetailsInitial extends RequestDetailsState {}

class LoadingRequestDetails extends RequestDetailsState{
}
class LoadedRequestDetails extends RequestDetailsState {
  final RequestDetailsEntity data;
  LoadedRequestDetails({
    required this.data,
  });
}


class RequestDetailsOfflineState extends RequestDetailsState {}

class RequestDetailsErrorState extends RequestDetailsState {
  final String message;
  const RequestDetailsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
