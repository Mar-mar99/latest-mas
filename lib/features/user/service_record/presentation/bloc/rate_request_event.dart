// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rate_request_bloc.dart';

abstract class RateRequestEvent extends Equatable {
  const RateRequestEvent();

  @override
  List<Object> get props => [];
}

class RateEvent extends RateRequestEvent {
  final int rating;
  final int requestId;
  final String comment;
  final bool isFav;
  RateEvent( {
    required this.rating,
    required this.requestId,
    required this.isFav,
    this.comment = '',
  });
}
