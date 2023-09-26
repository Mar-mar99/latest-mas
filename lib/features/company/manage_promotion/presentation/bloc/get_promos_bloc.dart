
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/user/promo_code/domain/use_cases/get_promos_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/promotion_entity.dart';
import '../../domain/use_cases/get_promotions_use_case.dart';

part 'get_promos_event.dart';
part 'get_promos_state.dart';

class GetPromosBloc extends Bloc<GetPromosEvent, GetPromosState> {
  final GetPromotionsUseCase getPromotionsUseCase;
  GetPromosBloc({
   required this.getPromotionsUseCase,
  }
  ) : super(GetPromosInitial()) {
    on<LoadPromosEvent>((event, emit)async {
        emit(LoadingGetPromos());
      final res = await getPromotionsUseCase.call();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetPromos(data: data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetPromosOfflineState());
        break;

      case NetworkErrorFailure:
        emit(GetPromosErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(GetPromosErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
