part of 'delete_promo_bloc.dart';

abstract class DeletePromoState extends Equatable {
  const DeletePromoState();

  @override
  List<Object> get props => [];
}

class DeletePromoInitial extends DeletePromoState {}

class LoadingDeletePromo extends DeletePromoState {}

class LoadedDeletePromo extends DeletePromoState {

}

class DeletePromoOfflineState extends DeletePromoState {}

class DeletePromoErrorState extends DeletePromoState {
  final String message;
  const DeletePromoErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
