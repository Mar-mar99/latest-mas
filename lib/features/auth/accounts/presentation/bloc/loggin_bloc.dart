import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/login_usecase.dart';

part 'loggin_event.dart';
part 'loggin_state.dart';

class LogginBloc extends Bloc<LogginEvent, LogginState> {
  final LoginUseCase loginUseCase;

  LogginBloc({
    required this.loginUseCase,
  }) : super(LogginState.empty()) {
    on<EmailLogginChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<PasswordLogginChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<SubmitLogginEvent>((event, emit) async {

      emit(state.copyWith(formSubmissionState: FormSubmittingState()));

      final result = await loginUseCase.call(
        email: state.email,
        password: state.password,
        type: event.loginUserType
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            formSubmissionState: _mapFailureToState(failure),
          ),
        ),
        (u) => emit(
          state.copyWith(
            formSubmissionState: FormSuccesfulState(),
          ),
        ),
      );
    });
  }

  FormSubmissionState _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return FormNoInternetState();

      case NetworkErrorFailure:
        return FormNetworkErrorState(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return const FormNetworkErrorState(
          message: 'Error',
        );
    }
  }
}
