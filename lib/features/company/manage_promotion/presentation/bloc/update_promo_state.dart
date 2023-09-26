part of 'update_promo_bloc.dart';

abstract class UpdatePromoState extends Equatable {
  const UpdatePromoState();

  @override
  List<Object> get props => [];
}

class UpdatePromoInitial extends UpdatePromoState {}

class LoadingUpdatePromo extends UpdatePromoState {}

class LoadedUpdatePromo extends UpdatePromoState {

}

class UpdatePromoOfflineState extends UpdatePromoState {}

class UpdatePromoErrorState extends UpdatePromoState {
  final String message;
  const UpdatePromoErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
