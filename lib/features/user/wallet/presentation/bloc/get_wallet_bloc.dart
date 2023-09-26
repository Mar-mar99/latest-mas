import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/use_cases/get_wallet_use_case.dart';


part 'get_wallet_event.dart';
part 'get_wallet_state.dart';

class GetWalletBloc extends Bloc<GetWalletEvent, GetWalletState> {
  final GetWalletUseCase getWalletUseCase;
  GetWalletBloc({required this.getWalletUseCase}) : super(GetWalletInitial()) {
    on<GetWalletDetailsEvent>((event, emit) async{
     emit(LoadingGetWallet());
      final res = await getWalletUseCase();
      res.fold((f) {
        _mapFailureToState(emit, f);
      }, (data) {
        emit(LoadedGetWallet(wallets:data));
      });
    });
  }

  _mapFailureToState(emit, Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        emit(GetWalletOfflineState());
        break;

      case NetworkErrorFailure:
        emit(
            GetWalletErrorState(message: (f as NetworkErrorFailure).message));
        break;

      default:
        emit(
            GetWalletErrorState(message: (f as NetworkErrorFailure).message));

        break;
    }
  }
}
