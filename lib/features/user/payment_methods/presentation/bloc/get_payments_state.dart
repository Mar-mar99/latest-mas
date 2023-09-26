part of 'get_payments_bloc.dart';

abstract class GetPaymentsState extends Equatable {
  const GetPaymentsState();

  @override
  List<Object> get props => [];
}

class GetPaymentsInitial extends GetPaymentsState {}

class LoadingGetPayments extends GetPaymentsState {}

class LoadedGetPayments extends GetPaymentsState {
  final List<PaymentsMethodEntity> payments;
  LoadedGetPayments({
    required this.payments,
  });

  @override
  List<Object> get props => [payments];
}

class GetPaymentsOfflineState extends GetPaymentsState {}

class GetPaymentsErrorState extends GetPaymentsState {
  final String message;
  const GetPaymentsErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
