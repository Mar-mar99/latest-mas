// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:masbar/core/utils/helpers/form_submission_state.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';
import '../../domain/use_cases/update_provider_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';

part 'edit_state_event.dart';
part 'edit_state_state.dart';

class EditStateBloc extends Bloc<EditStateEvent, EditStateState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UpdateCompanyProfileUseCase updateCompanyProfileUseCase;
  final UpdateProviderProfileUseCase updateProviderProfileUseCase;
  EditStateBloc({
    required this.updateUserProfileUseCase,
    required this.updateCompanyProfileUseCase,
    required this.updateProviderProfileUseCase,
  }) : super(EditStateState.empty()) {
    on<StateChangedEvent>((event, emit) {
      emit(state.copyWith(
        state: event.state,
      ));
    });

    on<StateUserSubmitEvent>((event, emit) async {
      emit(state.copyWith(formSubmissionState: FormSubmittingState()));
      final res = await updateUserProfileUseCase(
        firstName: event.firstName,
        lastName: event.lastName,
        state: state.state,
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


     on<StateCompanySubmitEvent>((event, emit) async {
      emit(state.copyWith(formSubmissionState: FormSubmittingState()));
      final res = await updateCompanyProfileUseCase(
        address: event.address,
        firstName: event.firstName,
        local: event.local,
        state: state.state
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

     on<StateProviderSubmitEvent>((event, emit) async {
      emit(state.copyWith(formSubmissionState: FormSubmittingState()));
      final res = await updateProviderProfileUseCase(
          firstName: event.firstName,
        lastName: event.lastName,
        state: state.state,
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
