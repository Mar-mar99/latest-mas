// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'request_fav_provider_bloc.dart';

abstract class RequestFavProviderEvent extends Equatable {
  const RequestFavProviderEvent();

  @override
  List<Object> get props => [];
}

class PaymentTypeChangedEvent extends RequestFavProviderEvent {
  final PaymentMethod paymentMethod;
  PaymentTypeChangedEvent({
    required this.paymentMethod,
  });
}

class PromoCodeChangedEvent extends RequestFavProviderEvent {
   final PromoCodeEntity? promoCode;
  PromoCodeChangedEvent({
    required this.promoCode,
  });
}

class WithPromoChangedEvent extends RequestFavProviderEvent {
   final bool withPromo;
  WithPromoChangedEvent({
    required this.withPromo,
  });
}

class StateChangedEvent extends RequestFavProviderEvent {
  final int state;
  StateChangedEvent({
    required this.state,
  });
}

class RefreshDataEvent extends RequestFavProviderEvent {
  final ServicePaymentType servicePaymentType;
  final int? stateId;
  final int serviceId;
  RefreshDataEvent(
      {required this.servicePaymentType,
      required this.serviceId,
      this.stateId});
}


class ProviderIdChangedEvent extends RequestFavProviderEvent {
  final int id;
  ProviderIdChangedEvent({
    required this.id,
  });
}

class AddImageChanged extends RequestFavProviderEvent {
 final File image;

  AddImageChanged({
    required this.image,
  });
}

class RemoveImageChanged extends RequestFavProviderEvent {
  final File image;

  RemoveImageChanged({
    required this.image,
  });
}
class IsScheduleChangedEvent extends RequestFavProviderEvent {

}

class DateChangedEvent extends RequestFavProviderEvent {
final DateTime date;
  DateChangedEvent({
    required this.date,
  });
}

class CoordsChangedEvent extends RequestFavProviderEvent {
  final double lat;
  final double lng;
  CoordsChangedEvent({
    required this.lat,
    required this.lng,
  });
}
class AddressChangedEvent extends RequestFavProviderEvent {
  final String address;
  AddressChangedEvent({
    required this.address,
  });

}
class DistanceChangedEvent extends RequestFavProviderEvent {
  final double distance;
  DistanceChangedEvent({
    required this.distance,
  });

}
class NoteChangedEvent extends RequestFavProviderEvent {
  final String note;
  NoteChangedEvent({
    required this.note,
  });
}
class SubmitRequestEvent extends RequestFavProviderEvent{

}

