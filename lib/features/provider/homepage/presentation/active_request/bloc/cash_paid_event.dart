// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cash_paid_bloc.dart';

abstract class CashPaidEvent extends Equatable {
  const CashPaidEvent();

  @override
  List<Object> get props => [];
}
class RecieveMoneyEvent extends CashPaidEvent {
  final int id;
  RecieveMoneyEvent({
    required this.id,
  });
}
