// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/accept_request_use_case.dart';
import '../../../domain/use_cases/reject_request_use_case.dart';

part 'accepting_rejecting_event.dart';
part 'accepting_rejecting_state.dart';

class AcceptingRejectingBloc
    extends Bloc<AcceptingRejectingEvent, AcceptingRejectingState> {
  final AcceptRequestUseCase acceptRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;
  AcceptingRejectingBloc({
    required this.acceptRequestUseCase,
    required this.rejectRequestUseCase,
  }) : super(AcceptingRejectingInitial()) {
    on<AcceptRequestEvent>((event, emit) async {
      emit(LoadingAcceptingRejecting());
      final res = await acceptRequestUseCase.call(requestId: event.id);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (r) => emit(
          LoadedAcceptingRejecting(isAccepted: true),
        ),
      );
    });

    on<RejectRequestEvent>((event, emit) async {
      emit(LoadingAcceptingRejecting());
      final res = await rejectRequestUseCase.call(requestId: event.id);
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (_) => emit(
          LoadedAcceptingRejecting(isAccepted: false),
        ),
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(AcceptingRejectingOfflineState());
        break;

      case NetworkErrorFailure:
        emit(AcceptingRejectingErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const AcceptingRejectingErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
