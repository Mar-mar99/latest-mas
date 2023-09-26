// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'charge_wallet_bloc.dart';

abstract class ChargeWalletEvent extends Equatable {
  const ChargeWalletEvent();

  @override
  List<Object> get props => [];
}

class ChargeEvent extends ChargeWalletEvent {
 final String amount;
  final int cardId;
  ChargeEvent({
    required this.amount,
    required this.cardId,
  });
}
