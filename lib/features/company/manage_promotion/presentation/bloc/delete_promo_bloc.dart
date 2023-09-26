// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/delete_promotion_use_case.dart';

part 'delete_promo_event.dart';
part 'delete_promo_state.dart';

class DeletePromoBloc extends Bloc<DeletePromoEvent, DeletePromoState> {
  final DeletlePromotionUseCase deletePromotionUseCase;
  DeletePromoBloc({
   required this.deletePromotionUseCase,
  }
  ) : super(DeletePromoInitial()) {
    on<DeleteEvent>((event, emit) async{
       emit(LoadingDeletePromo());
      final res = await deletePromotionUseCase.call(promoId: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedDeletePromo());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeletePromoOfflineState());
        break;

      case NetworkErrorFailure:
      
        emit(DeletePromoErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(DeletePromoErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
