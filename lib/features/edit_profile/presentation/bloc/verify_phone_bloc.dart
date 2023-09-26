import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/use_cases/verify_phone_use_case.dart';

part 'verify_phone_event.dart';
part 'verify_phone_state.dart';

class VerifyPhoneBloc extends Bloc<VerifyPhoneEvent, VerifyPhoneState> {
  final VeifyPhoneUseCase veifyPhoneUseCase;
  VerifyPhoneBloc({required this.veifyPhoneUseCase}) : super(VerifyPhoneInitial()) {
    on<VerifyEvent>((event, emit)async {
        emit(LoadingVerifyPhoneState());
      final res = await veifyPhoneUseCase(
        phone: event.number,
        code:event.otpCode,
        typeAuth: event.typeAuth,

      );
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (u) => emit(DoneVerifyPhoneState()),
      );
    });
  }
   _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(VerifyPhoneOfflineState());
        break;
      case NetworkErrorFailure:
        emit(VerifyPhoneErrorState(
          message: (f as NetworkErrorFailure).message,
        ));
        break;
      default:
        emit(VerifyPhoneErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
