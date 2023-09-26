// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_promo_bloc.dart';

abstract class UpdatePromoEvent extends Equatable {
  const UpdatePromoEvent();

  @override
  List<Object> get props => [];
}
class UpdateEvent extends UpdatePromoEvent {
  final int id;
    final String promo;
    final num discount;
    final DateTime expiration;
   
  UpdateEvent({
    required this.id,
    required this.promo,
    required this.discount,
    required this.expiration,

  });

}
