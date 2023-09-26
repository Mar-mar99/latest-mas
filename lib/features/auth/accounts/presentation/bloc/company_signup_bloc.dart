// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/errors/failures.dart';

import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/auth/accounts/domain/use%20cases/companysignup_usecase.dart';

import '../../../../user_emirate/domain/entities/uae_state_entity.dart';

part 'company_signup_event.dart';
part 'company_signup_state.dart';

class CompanySignupBloc extends Bloc<CompanySignupEvent, CompanySignupState> {
  final CompanySignupUseCase companySignupUseCase;
  CompanySignupBloc({
    required this.companySignupUseCase,
  }) : super(CompanySignupState.empty()) {
    on<CompanyTypeChangedEvent>((event, emit) {
      emit(state.copyWith(
          companyOwnerType: event.companyOwnerType,
          signupValidation: CompanySignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });

    on<CompanyNameChangedEvent>((event, emit) {
      emit(state.copyWith(
          companyName: event.companyName,
          signupValidation: CompanySignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<CompanyEmailChangedEvent>((event, emit) {
      emit(state.copyWith(
          email: event.email, formSubmissionState: const InitialFormState()));
    });
    on<CompanyAddressChangedEvent>((event, emit) {
      emit(state.copyWith(
          address: event.address,
          signupValidation: CompanySignupValidation.init,
          formSubmissionState: const InitialFormState()));
    });
    on<CompanyPhoneChangedEvent>((event, emit) {
      emit(state.copyWith(
          phone: event.phone, formSubmissionState: const InitialFormState()));
    });
    on<CompanyStateChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          states: event.states,
          mainBranch: UAEStateEntity.empty(),
          formSubmissionState: const InitialFormState()));
    });
    on<CompanyMainBranchChangedEvent>((event, emit) {
      emit(
        state.copyWith(
          signupValidation: CompanySignupValidation.init,
          mainBranch: event.mainBranch,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });
    on<CompanyProviderCountChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          providerCount: event.count,
          formSubmissionState: const InitialFormState()));
    });
    on<CompanyPasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          password: event.password,
          formSubmissionState: const InitialFormState()));
    });
    on<CompanyConfirmPasswordChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          confirmPassword: event.confirmPassword,
          formSubmissionState: const InitialFormState()));
    });
    on<AddDocumentChangedEvent>((event, emit) {
      List<File> newDocuments = state.documents.toList();
      File newFile = File(event.document.path);
      newDocuments.add(newFile);
      emit(
        state.copyWith(
          signupValidation: CompanySignupValidation.init,
          documents: newDocuments,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<RemoveDocumentChangedEvent>((event, emit) {
      List<File> newDocuments = state.documents.toList();
      newDocuments.remove(event.document);
      emit(
        state.copyWith(
          signupValidation: CompanySignupValidation.init,
          documents: newDocuments,
          formSubmissionState: const InitialFormState(),
        ),
      );
    });

    on<CompanyVerifyByChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          verifyByType: event.verifyByType,
          formSubmissionState: const InitialFormState()));
    });

    on<CompanyAgreeChangedEvent>((event, emit) {
      emit(state.copyWith(
          signupValidation: CompanySignupValidation.init,
          hasAgreed: event.hasAgreed,
          formSubmissionState: const InitialFormState()));
    });
    on<CompanySubmitEvent>((event, emit) async {
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
        ),
      );
      if (state.states .isEmpty) {
        emit(state.copyWith(
            formSubmissionState: const InitialFormState(),
            signupValidation: CompanySignupValidation.statesEmpty));
      } else if (state.mainBranch == UAEStateEntity.empty()) {
        emit(state.copyWith(
            formSubmissionState: const InitialFormState(),
            signupValidation: CompanySignupValidation.mainBranchNotSelected));
      } else if (!state.hasAgreed) {
        emit(state.copyWith(
            formSubmissionState: const InitialFormState(),
            signupValidation: CompanySignupValidation.hasnotAgreed));
      } else if (state.documents.length < 2) {
        emit(state.copyWith(
            formSubmissionState: const InitialFormState(),
            signupValidation: CompanySignupValidation.lessThanTwoDocuments));
      } else {
        final result = await companySignupUseCase(
          companyOwnerType: state.companyOwnerType,
          companyName: state.companyName,
          email: state.email,
          phone: state.phone,
          state: state.states.map((e) => e.id).toList(),
          mainBranch: state.mainBranch.id,
          providerCount: state.providerCount,
          address: state.address,
          password: state.password,
          confirmPassword: state.confirmPassword,
          documents: state.documents,
          verifyByType: state.verifyByType,
        );

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
