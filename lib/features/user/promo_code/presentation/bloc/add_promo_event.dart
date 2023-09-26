part of 'add_promo_bloc.dart';

abstract class AddPromoEvent extends Equatable {
  const AddPromoEvent();

  @override
  List<Object> get props => [];
}
class AddNewPromoEvent extends AddPromoEvent{
  final String promo;

  AddNewPromoEvent( {required this.promo});

}
