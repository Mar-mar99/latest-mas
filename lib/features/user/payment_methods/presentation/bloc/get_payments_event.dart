part of 'get_payments_bloc.dart';

abstract class GetPaymentsEvent extends Equatable {
  const GetPaymentsEvent();

  @override
  List<Object> get props => [];
}
class GetPaymentsMethodsEvent extends GetPaymentsEvent{}
