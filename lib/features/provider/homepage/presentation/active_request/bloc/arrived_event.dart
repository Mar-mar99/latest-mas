// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'arrived_bloc.dart';

abstract class ArrivedEvent extends Equatable {
  const ArrivedEvent();

  @override
  List<Object> get props => [];
}

class ArrivedToLocationEvent extends ArrivedEvent {
  final int id;
  ArrivedToLocationEvent({
    required this.id,
  });


}
