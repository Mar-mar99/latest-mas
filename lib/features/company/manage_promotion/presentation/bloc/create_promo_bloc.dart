import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use_cases/create_promotion_use_case.dart';

part 'create_promo_event.dart';
part 'create_promo_state.dart';

class CreatePromoBloc extends Bloc<CreatePromoEvent, CreatePromoState> {
  final CreatePromotionUseCase createPromotionUseCase;
  CreatePromoBloc({
    required this.createPromotionUseCase
  }) : super(CreatePromoInitial()) {
    on<CreateEvent>((event, emit) async{
       emit(LoadingCreatePromo());
      final res = await createPromotionUseCase(discount: event.discount,expiration: event.expiration,promo: event.promo,services: event.services,);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedCreatePromo());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(CreatePromoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(CreatePromoErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(CreatePromoErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
