part of 'cash_paid_bloc.dart';

abstract class CashPaidState extends Equatable {
  const CashPaidState();

  @override
  List<Object> get props => [];
}

class CashPaidInitial extends CashPaidState {}

class LoadingCashPaid extends CashPaidState{
}
class DoneCashPaid extends CashPaidState{}


class CashPaidOfflineState extends CashPaidState {}

class CashPaidErrorState extends CashPaidState {
  final String message;
  const CashPaidErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
