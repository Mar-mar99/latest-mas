import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/rate_provider_use_case.dart';

part 'rate_provider_event.dart';
part 'rate_provider_state.dart';

class RateProviderBloc extends Bloc<RateProviderEvent, RateProviderState> {
  final RateProviderUseCase rateProviderUseCase;

  RateProviderBloc({
    required this.rateProviderUseCase
  }) : super(RateProviderInitial()) {
    on<RateEvent>((event, emit) async{
      emit(LoadingRateProvider());
      final res = await rateProviderUseCase.call(
        rating: event.rating,
        requestId: event.requestId,
        comment: event.comment,
      );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (data) => emit(
                LoadedRateProvider(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(RateProviderOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            RateProviderErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const RateProviderErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
