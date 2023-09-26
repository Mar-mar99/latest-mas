// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'set_default_bloc.dart';

abstract class SetDefaultEvent extends Equatable {
  const SetDefaultEvent();

  @override
  List<Object> get props => [];
}
class SetDefaultCardEvent extends SetDefaultEvent {
  final int id;
  SetDefaultCardEvent({
    required this.id,
  });

}
