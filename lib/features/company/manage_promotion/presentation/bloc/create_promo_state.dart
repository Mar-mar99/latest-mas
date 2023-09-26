part of 'create_promo_bloc.dart';

abstract class CreatePromoState extends Equatable {
  const CreatePromoState();

  @override
  List<Object> get props => [];
}

class CreatePromoInitial extends CreatePromoState {}

class LoadingCreatePromo extends CreatePromoState {}

class LoadedCreatePromo extends CreatePromoState {
 
}

class CreatePromoOfflineState extends CreatePromoState {}

class CreatePromoErrorState extends CreatePromoState {
  final String message;
  const CreatePromoErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
