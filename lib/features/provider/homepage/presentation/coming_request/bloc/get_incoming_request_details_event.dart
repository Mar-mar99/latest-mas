// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_incoming_request_details_bloc.dart';

abstract class GetRequestDetailsEvent extends Equatable {
  const GetRequestDetailsEvent();

  @override
  List<Object> get props => [];
}
class GetDetailsEvent extends GetRequestDetailsEvent {
  final int id;
  GetDetailsEvent({
    required this.id,
  });

}
