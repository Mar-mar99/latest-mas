part of 'get_wallet_bloc.dart';

abstract class GetWalletEvent extends Equatable {
  const GetWalletEvent();

  @override
  List<Object> get props => [];
}
class GetWalletDetailsEvent extends GetWalletEvent{
  
}
