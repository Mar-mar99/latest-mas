part of 'add_promo_bloc.dart';

abstract class AddPromoState extends Equatable {
  const AddPromoState();

  @override
  List<Object> get props => [];
}

class AddPromoInitial extends AddPromoState {}

class LoadingAddPromo extends AddPromoState {}

class DoneAddPromo extends AddPromoState {
 
}

class AddPromoOfflineState extends AddPromoState {}

class AddPromoErrorState extends AddPromoState {
  final String message;
  const AddPromoErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
