// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use_cases/edit_password_use_case.dart';

part 'edit_password_event.dart';
part 'edit_password_state.dart';

class EditPasswordBloc extends Bloc<EditPasswordEvent, EditPasswordState> {
  final EditPasswordUseCase editPasswordUseCase;

  EditPasswordBloc({
    required this.editPasswordUseCase,
  }) : super(EditPasswordState.empty()) {
    on<CurrentPasswordChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          currentPassword: event.password,
          formSubmissionState: InitialFormState(),
        ),
      );
    });

    on<NewPasswordChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          newPassword: event.password,
          formSubmissionState: InitialFormState(),
        ),
      );
    });

    on<ConfirmPasswordChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          confirmPassword: event.password,
          formSubmissionState: InitialFormState(),
        ),
      );
    });

    on<SubmitEditPasswordEvent>((event, emit) async {
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
        ),
      );
      final res = await editPasswordUseCase.call(
        oldPassword: state.currentPassword,
        password: state.newPassword,
        passwordConfirmation: state.confirmPassword,
        typeAuth: event.typeAuth,
      );
      res.fold(
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
