part of 'rate_provider_bloc.dart';

abstract class RateProviderEvent extends Equatable {
  const RateProviderEvent();

  @override
  List<Object> get props => [];
}

class RateEvent extends RateProviderEvent {
  final int rating;
  final int requestId;
  final String comment;
  RateEvent({
    required this.rating,
    required this.requestId,
    this.comment = '',
  });
}
