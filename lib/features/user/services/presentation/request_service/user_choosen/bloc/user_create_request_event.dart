// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_create_request_bloc.dart';

abstract class UserCreateRequestEvent extends Equatable {
  const UserCreateRequestEvent();

  @override
  List<Object> get props => [];
}

class PaymentTypeChangedEvent extends UserCreateRequestEvent {
  final PaymentMethod paymentMethod;
  PaymentTypeChangedEvent({
    required this.paymentMethod,
  });
}

class PromoCodeChangedEvent extends UserCreateRequestEvent {
   final PromoCodeEntity? promoCode;
  PromoCodeChangedEvent({
    required this.promoCode,
  });
}
class WithPromoChangedEvent extends UserCreateRequestEvent {
   final bool? withPromo;
  WithPromoChangedEvent({
    required this.withPromo,
  });
}

class StateChangedEvent extends UserCreateRequestEvent {
  final int state;
  final String stateName;
  StateChangedEvent({
    required this.state,
    required this.stateName
  });
}

class RefreshDataEvent extends UserCreateRequestEvent {
  final ServicePaymentType servicePaymentType;
  final int? stateId;
  final String ? stateName;
  final int serviceId;
  RefreshDataEvent(
      {required this.servicePaymentType,
      required this.serviceId,
      this.stateId,
       this.stateName});
}

class AddAtributeChanged extends UserCreateRequestEvent {
  final int id;
  final String value;
  AddAtributeChanged({
    required this.id,
    required this.value,
  });
}

class RemoveAtributeChanged extends UserCreateRequestEvent {
  final int id;

  RemoveAtributeChanged({
    required this.id,
  });
}
class AddImageChanged extends UserCreateRequestEvent {
 final File image;

  AddImageChanged({
    required this.image,
  });
}

class RemoveImageChanged extends UserCreateRequestEvent {
  final File image;

  RemoveImageChanged({
    required this.image,
  });
}
class IsScheduleChangedEvent extends UserCreateRequestEvent {

}

class ProviderTypeChangedEvent extends UserCreateRequestEvent {
final ProviderStatus providerStatus;
  ProviderTypeChangedEvent({
    required this.providerStatus,
  });
}
class DateChangedEvent extends UserCreateRequestEvent {
final DateTime date;
  DateChangedEvent({
    required this.date,
  });
}

class CoordsChangedEvent extends UserCreateRequestEvent {
  final double lat;
  final double lng;
  CoordsChangedEvent({
    required this.lat,
    required this.lng,
  });
}
class AddressChangedEvent extends UserCreateRequestEvent {
  final String address;
  AddressChangedEvent({
    required this.address,
  });

}
class DistanceChangedEvent extends UserCreateRequestEvent {
  final double distance;
  DistanceChangedEvent({
    required this.distance,
  });

}

class ProviderIdChangedEvent extends UserCreateRequestEvent {
  final int id;
  ProviderIdChangedEvent({
    required this.id,
  });
}
class RequestIdChangedEvent extends UserCreateRequestEvent {
  final int id;
  RequestIdChangedEvent({
    required this.id,
  });
}
class NoteChangedEvent extends UserCreateRequestEvent {
  final String note;
  NoteChangedEvent({
    required this.note,
  });
}
class RequestOnlineProviderEvent extends UserCreateRequestEvent{

}

class RequestBusyProviderEvent extends UserCreateRequestEvent{

}
class RequestOfflineProviderEvent extends UserCreateRequestEvent{

}
