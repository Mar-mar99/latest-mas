// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cancel_after_accept_bloc.dart';

abstract class CancelAfterAcceptEvent extends Equatable {
  const CancelAfterAcceptEvent();

  @override
  List<Object> get props => [];
}

class CancelRequest extends CancelAfterAcceptEvent {
  final int id;
  final String reason;
  CancelRequest({
    required this.id,
    required this.reason,
  });
}
