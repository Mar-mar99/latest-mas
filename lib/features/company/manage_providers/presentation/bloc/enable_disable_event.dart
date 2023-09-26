// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'enable_disable_bloc.dart';

abstract class EnableDisableEvent extends Equatable {
  const EnableDisableEvent();

  @override
  List<Object> get props => [];
}

class EnableEvent extends EnableDisableEvent {
  final int id;
  EnableEvent({
    required this.id,
  });
  @override

  List<Object> get props => [id];
}

class DisableEvent extends EnableDisableEvent {
  final int id;
  DisableEvent({
    required this.id,
  });
  @override

  List<Object> get props => [id];
}
