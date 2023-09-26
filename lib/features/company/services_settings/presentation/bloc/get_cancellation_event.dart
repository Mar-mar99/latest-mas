// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_cancellation_bloc.dart';

abstract class GetCancellationEvent extends Equatable {
  const GetCancellationEvent();

  @override
  List<Object> get props => [];
}
class GetCancellationSettings extends GetCancellationEvent {
  final int serviceId;
  GetCancellationSettings({
    required this.serviceId,
  });
}
