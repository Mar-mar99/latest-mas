import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/logout_use_case.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';

part 'log_out_event.dart';
part 'log_out_state.dart';

class LogOutBloc extends Bloc<LogOutEvent, LogOutState> {
  final LogOutUseCase logOutUseCase;
  LogOutBloc({required this.logOutUseCase}) : super(LogOutInitial()) {
    on<LogOut>((event, emit) async {
      emit(LoadingLogOut());

      final res = await logOutUseCase.call(
        typeAuth: event.typeAuth,
      );
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(DoneLogOut());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(LogOutOfflineState());
        break;

      case NetworkErrorFailure:
        emit(LogOutErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const LogOutErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
