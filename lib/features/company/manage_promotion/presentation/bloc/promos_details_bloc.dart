import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/promotion_entity.dart';
import '../../domain/use_cases/get_promotion_details_use_case.dart';

part 'promos_details_event.dart';
part 'promos_details_state.dart';

class PromosDetailsBloc extends Bloc<PromosDetailsEvent, PromosDetailsState> {
 final GetPromotionDetailsUseCase getPromotionDetailsUseCase;
  PromosDetailsBloc({
    required this.getPromotionDetailsUseCase
  }) : super(PromosDetailsInitial()) {
    on<LoadPromosDetailsEvent>((event, emit) async{
        emit(LoadingPromosDetails());
      final res = await getPromotionDetailsUseCase.call(id: event.id);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedPromosDetails(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(PromosDetailsOfflineState());
        break;

      case NetworkErrorFailure:
        emit(PromosDetailsErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(PromosDetailsErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
