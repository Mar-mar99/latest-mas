import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/delete_account/domain/use_cases/delete_account_use_case.dart';

import '../../../../core/errors/failures.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase deleteAccountUseCase;
  DeleteAccountBloc({required this.deleteAccountUseCase})
      : super(DeleteAccountInitial()) {
    on<DeleteAccount>((event, emit) async {
      emit(LoadingDeleteAccount());
      final res = await deleteAccountUseCase(type: event.typeAuth);
      res.fold((failure) {
        _mapFailureToState(emit, failure);
      },
          (states) => emit(
                DoneDeleteAccount(),
              ));
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(DeleteAccountOfflineState());
        break;

      case NetworkErrorFailure:
        emit(DeleteAccountErrorState(
            message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const DeleteAccountErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
