// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';

import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/send_email_forget_password_usecase.dart';

part 'send_email_forget_password_event.dart';
part 'send_email_forget_password_state.dart';

class SendEmailForgetPasswordBloc
    extends Bloc<SendEmailForgetPasswordEvent, SendEmailForgetPasswordState> {
  final SendEmailForgetPasswordUseCase sendEmailForgetPasswordUseCase;
  SendEmailForgetPasswordBloc({
    required this.sendEmailForgetPasswordUseCase,
  }) : super(SendEmailForgetPasswordInitial()) {
    on<SendEmailEvent>((event, emit) async {
      emit(LoadingSendEmailForgetPassword());
      final res = await sendEmailForgetPasswordUseCase.call(
          email: event.email, typeAuth: event.typeAuth);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (id) => emit(
                DoneSendEmailForgetPassword(id: id),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SendEmailForgetPasswordOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SendEmailForgetPasswordErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SendEmailForgetPasswordErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
