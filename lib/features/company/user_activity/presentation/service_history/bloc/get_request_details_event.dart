part of 'get_request_details_bloc.dart';

abstract class GetRequestDetailsEvent extends Equatable {
  const GetRequestDetailsEvent();

  @override
  List<Object> get props => [];
}
class GetDetailsEvent extends GetRequestDetailsEvent {
  final String id;
  const GetDetailsEvent({
    required this.id
  });


}
