// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_request_details_bloc.dart';

abstract class GetRequestDetailsState extends Equatable {
  const GetRequestDetailsState();

  @override
  List<Object> get props => [];
}

class GetRequestDetailsInitial extends GetRequestDetailsState {}


class LoadingGetRequestDetails extends GetRequestDetailsState{
}
class DoneGetRequestDetails extends GetRequestDetailsState {
  final RequestDetailEntity data;
  DoneGetRequestDetails({
    required this.data,
  });
}


class GetRequestDetailsOfflineState extends GetRequestDetailsState {}

class GetRequestDetailsErrorState extends GetRequestDetailsState {
  final String message;
  const GetRequestDetailsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
