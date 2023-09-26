import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../domain/use cases/resend_code_usecase.dart';
import '../../domain/use cases/verify_account_usecase.dart';

part 'verify_account_event.dart';
part 'verify_account_state.dart';

class VerifyAccountBloc extends Bloc<VerifyAccountEvent, VerifyAccountState> {
  final VerifyAccountUsecase verifyAccountUsecase;
  final ResendCodeUsecase resendCodeUsecase;
  VerifyAccountBloc({required this.verifyAccountUsecase,required this.resendCodeUsecase})
      : super(VerifyAccountInitial()) {
    on<SendCodeEvent>((event, emit) async{
      emit(VerifyAccountLoading());
      final res = await verifyAccountUsecase.call(otp: event.code, );
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (_) => emit(
                DoneVerifyAccount(),
              ));
    });





    on<ReSendCodeEvent>((event, emit)async {
   emit(VerifyAccountLoading());
      final res = await  resendCodeUsecase.call();

      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (_) => emit(
                DoneResendCode(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(VerifyAccountOffline());
        break;

      case NetworkErrorFailure:
        emit(VerifyAccountNetworkError(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit( VerifyAccountNetworkError(
          message: 'Error',
        ));
        break;
    }
  }
}
