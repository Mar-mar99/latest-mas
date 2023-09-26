// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/services_prices_entity.dart';
import '../../domain/use_cases/update_price_use_case.dart';

part 'update_prices_event.dart';
part 'update_prices_state.dart';

class UpdatePricesBloc extends Bloc<UpdatePricesEvent, UpdatePricesState> {
 final UpdatePriceUseCase updatePriceUseCase;
  UpdatePricesBloc({
   required this.updatePriceUseCase,
  }
  ) : super(UpdatePricesState()) {
    on<UpdateEvent>((event, emit) async{
      emit(LoadingUpdatePrices());
      final res = await updatePriceUseCase(fixed: event.fixed.toDouble(),hourly: event.hourly.toDouble(),serviceId: event.serviceId,stateId: event.stateId,);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (states) => emit(
                LoadedUpdatePrices(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UpdatePricesOfflineState());
        break;

      case NetworkErrorFailure:
        emit(UpdatePricesErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const UpdatePricesErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
