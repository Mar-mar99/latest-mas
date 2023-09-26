// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'request_details_bloc.dart';

abstract class RequestDetailsEvent extends Equatable {
  const RequestDetailsEvent();

  @override
  List<Object> get props => [];
}
class LoadRequestDetails extends RequestDetailsEvent {
  final int id;
  LoadRequestDetails({
    required this.id,
  });
}
