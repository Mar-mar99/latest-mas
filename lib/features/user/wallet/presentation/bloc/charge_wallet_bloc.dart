import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/use_cases/charge_wallet_use_case.dart';

part 'charge_wallet_event.dart';
part 'charge_wallet_state.dart';

class ChargeWalletBloc extends Bloc<ChargeWalletEvent, ChargeWalletState> {
  final ChargeWalletUseCase  chargeWalletUseCase;
  ChargeWalletBloc({required this.chargeWalletUseCase}) : super(ChargeWalletInitial()) {
    on<ChargeEvent>((event, emit)async{

      emit(LoadingChargeWallet());
      final res = await chargeWalletUseCase.call(amount: event.amount, cardId:event. cardId);
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedChargeWallet());
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(ChargeWalletOfflineState());
        break;

      case NetworkErrorFailure:
        emit(ChargeWalletErrorState(message: (f as NetworkErrorFailure).message));
    
        break;

      default:
        emit(ChargeWalletErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}

