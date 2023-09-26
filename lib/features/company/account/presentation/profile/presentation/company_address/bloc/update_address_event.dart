// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_address_bloc.dart';

abstract class UpdateAddressEvent extends Equatable {
  const UpdateAddressEvent();

  @override
  List<Object> get props => [];
}

class UpdateAddress extends UpdateAddressEvent {
  final String address;
  UpdateAddress({
    required this.address,
  });
}
