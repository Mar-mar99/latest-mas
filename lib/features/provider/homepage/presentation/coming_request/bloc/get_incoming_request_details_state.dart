part of 'get_incoming_request_details_bloc.dart';

abstract class GetIncomingRequestDetailsState extends Equatable {
  const GetIncomingRequestDetailsState();

  @override
  List<Object> get props => [];
}

class GetRequestDetailsInitial extends GetIncomingRequestDetailsState {}


class LoadingGetRequestDetails extends GetIncomingRequestDetailsState{}
class LoadedGetRequestDetails extends GetIncomingRequestDetailsState {
  final RequestProviderEntity data;
  LoadedGetRequestDetails({
    required this.data,
  });
  @override

  List<Object> get props => [data];
}


class GetRequestDetailsOfflineState extends GetIncomingRequestDetailsState{}

class GetRequestDetailsErrorState extends GetIncomingRequestDetailsState {
  final String message;
  const GetRequestDetailsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

