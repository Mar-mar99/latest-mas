part of 'get_wallet_bloc.dart';

abstract class GetWalletState extends Equatable {
  const GetWalletState();

  @override
  List<Object> get props => [];
}

class GetWalletInitial extends GetWalletState {}

class LoadingGetWallet extends GetWalletState {}

class LoadedGetWallet extends GetWalletState {
  final List<WalletEntity> wallets;
  LoadedGetWallet({
    required this.wallets,
  });

  @override
  List<Object> get props => [wallets];
}

class GetWalletOfflineState extends GetWalletState {}

class GetWalletErrorState extends GetWalletState {
  final String message;
  const GetWalletErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
