// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_prices_bloc.dart';

class UpdatePricesState extends Equatable {

  const UpdatePricesState();

  @override
  List<Object> get props => [];
}


class LoadingUpdatePrices extends UpdatePricesState{}
class LoadedUpdatePrices extends UpdatePricesState {

}


class UpdatePricesOfflineState extends UpdatePricesState{}

class UpdatePricesErrorState extends UpdatePricesState {
  final String message;
  const UpdatePricesErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
