import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/add_promo_use_case.dart';

part 'add_promo_event.dart';
part 'add_promo_state.dart';

class AddPromoBloc extends Bloc<AddPromoEvent, AddPromoState> {
  final AddPromoUseCase addPromoUseCase;
  AddPromoBloc({required this.addPromoUseCase}) : super(AddPromoInitial()) {
    on<AddNewPromoEvent>((event, emit) async {
      emit(LoadingAddPromo());
      final res = await addPromoUseCase(promoCode: event.promo);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(DoneAddPromo());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AddPromoOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AddPromoErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(AddPromoErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
