// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'start_bloc.dart';

abstract class StartEvent extends Equatable {
  const StartEvent();

  @override
  List<Object> get props => [];
}

class StartRequestEvent extends StartEvent {
  final int id;
  StartRequestEvent({
    required this.id,
  });
}
