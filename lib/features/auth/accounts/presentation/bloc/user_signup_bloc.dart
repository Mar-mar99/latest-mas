import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use%20cases/usersignup_usecase.dart';

part 'user_signup_event.dart';
part 'user_signup_state.dart';

class UserSignupBloc extends Bloc<UserSignupEvent, UserSignupState> {
  final UserSignupUseCase signupUseCase;
  UserSignupBloc({
    required this.signupUseCase,
  }) : super(UserSignupState.empty()) {
    on<FirstNameChangedEvent>((event, emit) {
      emit(state.copyWith(
          firstName: event.firstName,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<LastNameChangedEvent>((event, emit) {
      emit(state.copyWith(
          lastName: event.lastName,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<EmailChangedEvent>((event, emit) {
      emit(state.copyWith(
          email: event.email,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<PhoneChangedEvent>((event, emit) {
      emit(state.copyWith(
          phone: event.phone,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<StateChangedEvent>((event, emit) {
      emit(state.copyWith(
          state: event.state,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<PasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          password: event.password,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<ConfirmPasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          confirmPassword: event.confirmPassword,
          validation: SignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<SubmitEvent>((event, emit) async {
      emit(state.copyWith(formSubmissionState: FormSubmittingState()));
      if (state.state == 0) {
        emit(
          state.copyWith(
            validation: SignupValidation.stateNotSelected,
            formSubmissionState: const InitialFormState(),
          ),
        );
      } else {
        final result = await signupUseCase.call(
            email: state.email,
            firstName: state.firstName,
            lastName: state.lastName,
            phone: state.phone,
            password: state.password,
            state: state.state);

        result.fold(
          (failure) => emit(
            state.copyWith(
               validation: SignupValidation.init,
              formSubmissionState: _mapFailureToState(
                failure,
              ),
            ),
          ),
          (u) => emit(
            state.copyWith(
                    validation: SignupValidation.init,
              formSubmissionState: FormSuccesfulState(),
            ),
          ),
        );
      }
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
