import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/entities/request_provider_entity.dart';
import '../../../domain/use_cases/get_current_request_use_case.dart';

part 'current_request_event.dart';
part 'current_request_state.dart';

class CurrentRequestBloc
    extends Bloc<CurrentRequestEvent, CurrentRequestState> {
  final GetCurrentRequestUseCase getCurrentRequestUseCase;
  CurrentRequestBloc({required this.getCurrentRequestUseCase})
      : super(CurrentRequestInitial()) {
    on<GetCurrentRequestEvent>((event, emit) async {
      emit(LoadingCurrentRequest());
      final res = await getCurrentRequestUseCase.call();
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          if (data == null) {
            emit(LoadedCurrentRequest(hasCurrent: false));
          } else {
            emit(LoadedCurrentRequest(hasCurrent: true, data: data));
          }
        },
      );
    });


     on<RefreshCurrentRequestEvent>((event, emit) async {
      emit(RefreshingCurrentRequest());
      final res = await getCurrentRequestUseCase.call();
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          if (data == null) {
            emit(RefreshedCurrentRequest(hasCurrent: false));
          } else {
            emit(RefreshedCurrentRequest(hasCurrent: true, data: data));
          }
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(CurrentRequestOfflineState());
        break;

      case NetworkErrorFailure:
        emit(CurrentRequestErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const CurrentRequestErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
