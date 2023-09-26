// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'set_cancellation_bloc.dart';

abstract class SetCancellationEvent extends Equatable {
  const SetCancellationEvent();

  @override
  List<Object> get props => [];
}
class SetCancellationSettings extends SetCancellationEvent {
  final int serviceId;
  final bool hasCancellationFees;
    final double fees;
  SetCancellationSettings({
    required this.serviceId,
    required this.hasCancellationFees,
    required this.fees,
  });
}
