// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_providers_bloc.dart';

abstract class SearchProvidersEvent extends Equatable {
  const SearchProvidersEvent();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends SearchProvidersEvent {
  final int state;
  final double lat;
  final double lng;
  final String address;
  final int serviceType;
  final ServicePaymentType paymentStatus;
  final PaymentMethod paymentMethod;
  final int distance;
  final DateTime? scheduleDate;
  final DateTime? scheduleTime;
  final String? notes;
  final String? promoCode;
  final Map<int, dynamic> selectedAttributes;
  final List<File> images;
  GetProvidersEvent({
    required this.state,
    this.lat = 0,
    this.lng = 0,
    this.address = '',
    required this.serviceType,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.distance,
    this.scheduleDate,
    this.scheduleTime,
    this.notes,
    this.promoCode,
    this.selectedAttributes=const {} ,
    this.images = const [],
  });
}
