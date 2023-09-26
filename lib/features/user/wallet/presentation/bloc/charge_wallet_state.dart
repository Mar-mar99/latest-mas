part of 'charge_wallet_bloc.dart';

abstract class ChargeWalletState extends Equatable {
  const ChargeWalletState();

  @override
  List<Object> get props => [];
}

class ChargeWalletInitial extends ChargeWalletState {}

class LoadingChargeWallet extends ChargeWalletState {}

class LoadedChargeWallet extends ChargeWalletState {

}

class ChargeWalletOfflineState extends ChargeWalletState {}

class ChargeWalletErrorState extends ChargeWalletState {
  final String message;
  const ChargeWalletErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
