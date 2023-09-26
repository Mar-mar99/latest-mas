import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/update_provider_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';

part 'edit_name_event.dart';
part 'edit_name_state.dart';

class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UpdateProviderProfileUseCase updateProviderProfileUseCase;
  EditNameBloc(
      {required this.updateUserProfileUseCase,
      required this.updateProviderProfileUseCase})
      : super(InitEditNameState()) {
        on<SubmitUserNameEvent>((event, emit) async {
      emit(
       LoadingEditNameState()
      );
      final res = await updateUserProfileUseCase(
        firstName: event.firstName,
        lastName: event.lastName,
        state: event.state,
      );
      res.fold(
        (failure) => emit(
          _mapFailureToState(emit,failure),

        ),
        (u) => emit(
         DoneEditNameState()
        ),
      );
    });


     on<SubmitProviderNameEvent>((event, emit) async {
       emit(
       LoadingEditNameState()
      );
      final res = await updateProviderProfileUseCase(
        firstName: event.firstName,
        lastName: event.lastName,
        state: event.state,
      );
       res.fold(
        (failure) => emit(
          _mapFailureToState(emit,failure),

        ),
        (u) => emit(
         DoneEditNameState()
        ),
      );
    });
  }
    _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(EditNameOfflineState());
        break;
      case NetworkErrorFailure:
        emit(EditNameErrorState(
          message: (f as NetworkErrorFailure).message,
        ));
        break;
      default:
        emit(EditNameErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
