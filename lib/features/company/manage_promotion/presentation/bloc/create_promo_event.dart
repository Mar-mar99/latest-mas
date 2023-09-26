// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_promo_bloc.dart';

abstract class CreatePromoEvent extends Equatable {
  const CreatePromoEvent();

  @override
  List<Object> get props => [];
}
class CreateEvent extends CreatePromoEvent {
    final String promo;
    final num discount;
    final DateTime expiration;
    final List<int> services;
  CreateEvent({
    required this.promo,
    required this.discount,
    required this.expiration,
    required this.services,
  });
}
