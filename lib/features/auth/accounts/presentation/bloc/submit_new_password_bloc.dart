// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use cases/submit_new_password_usecase.dart';

part 'submit_new_password_event.dart';
part 'submit_new_password_state.dart';

class SubmitNewPasswordBloc
    extends Bloc<SubmitNewPasswordEvent, SubmitNewPasswordState> {
  final SubmitNewPasswordUseCase submitNewPasswordUseCase;

  SubmitNewPasswordBloc({
    required this.submitNewPasswordUseCase,
  }) : super(SubmitNewPasswordInitial()) {
    on<SubmitDataEvent>((event, emit) async {
      emit(LoadingSubmitNewPasswordState());
      final res = await submitNewPasswordUseCase.call(
        id: event.id,
        password: event.password,
        confirmPassword: event.confirmPassword,
        otp: event.code,
        typeAuth: event.typeAuth,
      );
      res.fold(
        (l) { _mapFailureToState(emit,l);},
        (r) => emit(
          DoneSubmitNewPasswordState(),
        ),
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    print('failure is ${f.runtimeType.toString()}');
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(SubmitNewPasswordStateOfflineState());
        break;

      case NetworkErrorFailure:
        emit(SubmitNewPasswordStateErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const SubmitNewPasswordStateErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
