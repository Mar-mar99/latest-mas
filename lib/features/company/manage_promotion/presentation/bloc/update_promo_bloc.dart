// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/update_promotion_use_case.dart';

part 'update_promo_event.dart';
part 'update_promo_state.dart';

class UpdatePromoBloc extends Bloc<UpdatePromoEvent, UpdatePromoState> {
  final UpdatePromotionUseCase updatePromotionUseCase;
  UpdatePromoBloc({
    required this.updatePromotionUseCase,
  }) : super(UpdatePromoInitial()) {
    on<UpdateEvent>((event, emit) async {
      emit(LoadingUpdatePromo());
      final res = await updatePromotionUseCase.call(
        promoId: event.id,
        discount: event.discount,
        expiration: event.expiration,
        promo: event.promo,
      );
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedUpdatePromo());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UpdatePromoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            UpdatePromoErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(
            UpdatePromoErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
