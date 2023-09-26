// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_request_bloc.dart';

abstract class CreateRequestEvent extends Equatable {
  const CreateRequestEvent();

  @override
  List<Object> get props => [];
}

class PaymentTypeChangedEvent extends CreateRequestEvent {
  final PaymentMethod paymentMethod;
  PaymentTypeChangedEvent({
    required this.paymentMethod,
  });
}

class PromoCodeChangedEvent extends CreateRequestEvent {
   final PromoCodeEntity? promoCode;
  PromoCodeChangedEvent({
    required this.promoCode,
  });
}

class WithPromoChangedEvent extends CreateRequestEvent {
   final bool withPromo;
  WithPromoChangedEvent({
    required this.withPromo,
  });
}
class StateChangedEvent extends CreateRequestEvent {
  final int state;
  StateChangedEvent({
    required this.state,
  });
}

class RefreshDataEvent extends CreateRequestEvent {
  final ServicePaymentType servicePaymentType;
  final int? stateId;
  final int serviceId;
  RefreshDataEvent(
      {required this.servicePaymentType,
      required this.serviceId,
      this.stateId});
}

class AddAtributeChanged extends CreateRequestEvent {
  final int id;
  final String value;
  AddAtributeChanged({
    required this.id,
    required this.value,
  });
}

class RemoveAtributeChanged extends CreateRequestEvent {
  final int id;

  RemoveAtributeChanged({
    required this.id,
  });
}
class AddImageChanged extends CreateRequestEvent {
 final File image;

  AddImageChanged({
    required this.image,
  });
}

class RemoveImageChanged extends CreateRequestEvent {
  final File image;

  RemoveImageChanged({
    required this.image,
  });
}
class IsScheduleChangedEvent extends CreateRequestEvent {

}

class DateChangedEvent extends CreateRequestEvent {
final DateTime date;
  DateChangedEvent({
    required this.date,
  });
}

class CoordsChangedEvent extends CreateRequestEvent {
  final double lat;
  final double lng;
  CoordsChangedEvent({
    required this.lat,
    required this.lng,
  });
}
class AddressChangedEvent extends CreateRequestEvent {
  final String address;
  AddressChangedEvent({
    required this.address,
  });

}
class DistanceChangedEvent extends CreateRequestEvent {
  final double distance;
  DistanceChangedEvent({
    required this.distance,
  });

}
class NoteChangedEvent extends CreateRequestEvent {
  final String note;
  NoteChangedEvent({
    required this.note,
  });
}
class SubmitRequestEvent extends CreateRequestEvent{

}

