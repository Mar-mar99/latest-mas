part of 'remove_service_code_bloc.dart';

abstract class RemoveServiceCodeEvent extends Equatable {
  const RemoveServiceCodeEvent();

  @override
  List<Object> get props => [];
}

class RemoveServicePromo extends RemoveServiceCodeEvent {
  final int promoId;
  final int serviceId;
  RemoveServicePromo({
    required this.promoId,
    required this.serviceId,
  });
}
