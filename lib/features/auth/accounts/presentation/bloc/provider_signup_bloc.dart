// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/providersignup_usecase.dart';

part 'provider_signup_event.dart';
part 'provider_signup_state.dart';

class ProviderSignupBloc
    extends Bloc<ProviderSignupEvent, ProviderSignupState> {
  final ProviderSignupUsecase providerSignupUsecase;

  ProviderSignupBloc({
    required this.providerSignupUsecase,
  }) : super(ProviderSignupState.empty()) {
    on<ProviderFirstNameChangedEvent>((event, emit) {
      emit(state.copyWith(
          firstName: event.firstName,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<ProviderLastNameChangedEvent>((event, emit) {
      emit(state.copyWith(
          lastName: event.lastName,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<ProviderEmailChangedEvent>((event, emit) {
      emit(state.copyWith(
          validation: ProviderSignupValidation.init,
          email: event.email,
          formSubmissionState: const InitialFormState()));
    });

    on<ProviderPhoneChangedEvent>((event, emit) {
      emit(state.copyWith(
          validation: ProviderSignupValidation.init,
          phone: event.phone,
          formSubmissionState: const InitialFormState()));
    });
    on<ProviderCodeChangedEvent>((event, emit) {
      emit(state.copyWith(
          code: event.code,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<ProviderPasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          password: event.password,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<ProviderConfirmPasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          confirmPassword: event.confirmPassword,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<ProviderAddDocumentEvent>((event, emit) {
      List<File> newDocuments = state.documents.toList();
      File newFile = File(event.document.path);
      newDocuments.add(newFile);
      emit(
        state.copyWith(
          documents: newDocuments,
          validation: ProviderSignupValidation.init,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<ProviderRemoveDocumentEvent>((event, emit) {
      List<File> newDocuments = state.documents.toList();
      newDocuments.remove(event.document);
      emit(
        state.copyWith(
          validation: ProviderSignupValidation.init,
          documents: newDocuments,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<ProviderSubmitEvent>((event, emit) async {
      emit(
        state.copyWith(
          validation: ProviderSignupValidation.init,
          formSubmissionState: FormSubmittingState(),
        ),
      );
      if (state.documents.length < 2) {
        emit(state.copyWith(
          formSubmissionState: const InitialFormState(),
          validation: ProviderSignupValidation.lessThanTwoDocuments,
        ));
      } else {
        final result = await providerSignupUsecase(
            confirmPassword: state.confirmPassword,
            documents: state.documents,
            email: state.email,
            password: state.password,
            phone: state.phone,
            code: state.code,
            firstName: state.firstName,
            lastName: state.lastName);

        result.fold(
          (failure) => emit(
            state.copyWith(
              formSubmissionState: _mapFailureToState(
                failure,
              ),
            ),
          ),
          (u) => emit(
            state.copyWith(
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
