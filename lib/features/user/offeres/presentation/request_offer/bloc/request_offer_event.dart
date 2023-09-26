part of 'request_offer_bloc.dart';

abstract class RequestOfferEvent extends Equatable {
  const RequestOfferEvent();

  @override
  List<Object> get props => [];
}

class PaymentTypeChangedEvent extends RequestOfferEvent {
  final PaymentMethod paymentMethod;
  PaymentTypeChangedEvent({
    required this.paymentMethod,
  });
}

class PromoCodeChangedEvent extends RequestOfferEvent {
   final int? promoCode;
  PromoCodeChangedEvent({
    required this.promoCode,
  });
}


class StateChangedEvent extends RequestOfferEvent {
  final int state;
  StateChangedEvent({
    required this.state,
  });
}

class RefreshDataEvent extends RequestOfferEvent {
  final ServicePaymentType servicePaymentType;
  final int? stateId;
  final int serviceId;
  RefreshDataEvent(
      {required this.servicePaymentType,
      required this.serviceId,
      this.stateId});
}


class ProviderIdChangedEvent extends RequestOfferEvent {
  final int id;
  ProviderIdChangedEvent({
    required this.id,
  });
}

class AddImageChanged extends RequestOfferEvent {
 final File image;

  AddImageChanged({
    required this.image,
  });
}

class RemoveImageChanged extends RequestOfferEvent {
  final File image;

  RemoveImageChanged({
    required this.image,
  });
}
class IsScheduleChangedEvent extends RequestOfferEvent {

}

class DateChangedEvent extends RequestOfferEvent {
final DateTime date;
  DateChangedEvent({
    required this.date,
  });
}

class CoordsChangedEvent extends RequestOfferEvent {
  final double lat;
  final double lng;
  CoordsChangedEvent({
    required this.lat,
    required this.lng,
  });
}
class AddressChangedEvent extends RequestOfferEvent {
  final String address;
  AddressChangedEvent({
    required this.address,
  });

}
class DistanceChangedEvent extends RequestOfferEvent {
  final double distance;
  DistanceChangedEvent({
    required this.distance,
  });

}
class NoteChangedEvent extends RequestOfferEvent {
  final String note;
  NoteChangedEvent({
    required this.note,
  });
}
class SubmitRequestEvent extends RequestOfferEvent{

}

