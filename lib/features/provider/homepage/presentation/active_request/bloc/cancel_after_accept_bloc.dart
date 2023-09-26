// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/provider/homepage/presentation/active_request/bloc/arrived_bloc.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/cancel_after_request_use_case.dart';

part 'cancel_after_accept_event.dart';
part 'cancel_after_accept_state.dart';

class CancelAfterAcceptBloc extends Bloc<CancelAfterAcceptEvent, CancelAfterAcceptState> {
  final CancelAfterRequestUseCase cancelAfterRequestUseCase;

  CancelAfterAcceptBloc({
    required this.cancelAfterRequestUseCase,
  }) : super(CancelInitial()) {
    on<CancelRequest>((event, emit) async {
      emit(LoadingCancel());

      final res = await cancelAfterRequestUseCase.call(
          id: event.id, reason: event.reason);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          print('done');
          emit(DoneCancel());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(CancelOfflineState());
        break;

      case NetworkErrorFailure:
        emit(CancelErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const CancelErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
