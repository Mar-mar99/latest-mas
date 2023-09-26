// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/helpers/form_submission_state.dart';
import '../../domain/use_cases/update_phone_use_case.dart';

part 'update_phone_event.dart';
part 'update_phone_state.dart';

class UpdatePhoneBloc extends Bloc<UpdatePhoneEvent, UpdatePhoneState> {
  final UpdatePhoneUseCase updatePhoneUseCase;
  UpdatePhoneBloc({required this.updatePhoneUseCase})
      : super(InitUpdatePhoneState()) {
    on<UserPhoneSubmitEvent>((event, emit) async {
      emit(LoadingUpdatePhoneState());
      final res = await updatePhoneUseCase(
        phone: event.phone,
        typeAuth: event.typeAuth,
      );
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (u) => emit(DoneUpdatePhoneState()),
      );
    });
  }
   _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(UpdatePhoneOfflineState());
        break;
      case NetworkErrorFailure:
        emit(UpdatePhoneErrorState(
          message: (f as NetworkErrorFailure).message,
        ));
        break;
      default:
        emit(UpdatePhoneErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
