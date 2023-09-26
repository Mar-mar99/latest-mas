import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/cancel_request_use_case.dart';

part 'cancel_user_request_event.dart';
part 'cancel_user_request_state.dart';

class CancelUserRequestBloc extends Bloc<CancelUserRequestEvent, CancelUserRequestState> {
  final CancelRequestUseCase cancelRequestUseCase;
  CancelUserRequestBloc({required this.cancelRequestUseCase}) : super(CancelUserRequestInitial()) {
    on<CancelUserRequest>((event, emit) async {
      emit(LoadingCancelUserRequest());

      final res = await cancelRequestUseCase.call(
          id: event.id, reason: event.reason);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          print('done');
          emit(DoneCancelUserRequest());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(CancelUserRequestOfflineState());
        break;

      case NetworkErrorFailure:
        emit(CancelUserRequestErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const CancelUserRequestErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}

