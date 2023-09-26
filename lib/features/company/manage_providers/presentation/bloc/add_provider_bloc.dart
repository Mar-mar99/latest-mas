// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use_cases/invite_provider_use_case.dart';

part 'add_provider_event.dart';
part 'add_provider_state.dart';

class AddProviderBloc extends Bloc<AddProviderEvent, AddProviderState> {
  final InviteProviderUseCase inviteProviderUseCase;
  AddProviderBloc({
    required this.inviteProviderUseCase,
  }) : super(AddProviderState.empty()) {
    on<FirstNameChangedEvent>((event, emit) {
       print('first changed');
      emit(
        state.copyWith(
          firstName: event.firstName,
          formSubmissionState: const InitialFormState(),
          validation: InviteProviderValidation.init,
        ),
      );
    });
    on<LastNameChangedEvent>((event, emit) { print('last changed');
      emit(
        state.copyWith(
          lastName: event.lastName,
          formSubmissionState: const InitialFormState(),
          validation: InviteProviderValidation.init,
        ),
      );
    });


    on<PhoneChangedEvent>((event, emit) { print('phone changed');
      emit(
        state.copyWith(
          phone: event.phone,
          formSubmissionState: const InitialFormState(),
          validation: InviteProviderValidation.init,
        ),
      );
    });

    on<StateChangedEvent>((event, emit) {
      print('state changed');
      emit(
        state.copyWith(
          state: event.state,
          formSubmissionState: const InitialFormState(),
          validation: InviteProviderValidation.init,
        ),
      );
    });
    on<InviteEvent>((event, emit) async {
      print('the state is $state');
      emit(
        state.copyWith(
          formSubmissionState: FormSubmittingState(),
          validation: InviteProviderValidation.init,
        ),
      );
      if (state.state == 0) {
       emit( state.copyWith(
          formSubmissionState: const InitialFormState(),
          validation: InviteProviderValidation.stateNotSelected,
        ));
      } else {
        final res = await inviteProviderUseCase.call(
          firstName: state.firstName,
          lastName: state.lastName,
          phone: state.phone,
          state: state.state,
        );

        res.fold(
          (failure) => emit(
            state.copyWith(
              formSubmissionState: _mapFailureToState(
                failure,
              ),
            ),
          ),
          (_) => emit(state.copyWith(
            formSubmissionState: FormSuccesfulState(),
            validation: InviteProviderValidation.init,
          )),
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
