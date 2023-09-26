part of 'update_address_bloc.dart';

abstract class UpdateAddressState extends Equatable {
  const UpdateAddressState();

  @override
  List<Object> get props => [];
}

class UpdateAddressInitial extends UpdateAddressState {}

class LoadingUpdateAddress extends UpdateAddressState{}
class LoadedUpdateAddress extends UpdateAddressState {
}


class UpdateAddressOfflineState extends UpdateAddressState{}

class UpdateAddressErrorState extends UpdateAddressState {
  final String message;
  const UpdateAddressErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

