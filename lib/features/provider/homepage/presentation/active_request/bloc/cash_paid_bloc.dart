import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../domain/use_cases/recieve_cash_use_case.dart';

part 'cash_paid_event.dart';
part 'cash_paid_state.dart';

class CashPaidBloc extends Bloc<CashPaidEvent, CashPaidState> {
  final RecieveCashUseCase recieveCashUseCase;
  CashPaidBloc({required this.recieveCashUseCase}) : super(CashPaidInitial()) {
    on<RecieveMoneyEvent>((event, emit) async {
      emit(LoadingCashPaid());

      final res = await recieveCashUseCase.call(
        id: event.id,
      );
      res.fold(
        (failure) {
          _mapFailureToState(emit, failure);
        },
        (data) {
          emit(DoneCashPaid());
        },
      );
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(CashPaidOfflineState());
        break;

      case NetworkErrorFailure:
        emit(CashPaidErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(const CashPaidErrorState(
          message: 'Error',
        ));
        break;
    }
  }
}
