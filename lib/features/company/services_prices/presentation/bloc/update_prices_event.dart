// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_prices_bloc.dart';

abstract class UpdatePricesEvent extends Equatable {
  const UpdatePricesEvent();

  @override
  List<Object> get props => [];
}
class UpdateEvent extends UpdatePricesEvent {
    final int serviceId;
    final int stateId;
    final double fixed;
    final double hourly;
  UpdateEvent({
    required this.serviceId,
    required this.stateId,
    required this.fixed,
    required this.hourly,
  });
}
