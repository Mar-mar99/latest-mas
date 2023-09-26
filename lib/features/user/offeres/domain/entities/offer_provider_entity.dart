// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OfferProviderEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String rating;
  final int ratingCount;
  final int promoCodeId;
  final DateTime expiredDatePromo;
  final num discountPercentage;
  final String fixedPrice;
  final String hourlyPrice;
  final String cancellationFee;
  final List<Attrs> attributes;
  final bool isFavorite;
  final bool isBusy;
  final bool expertOnline;
  final int completedRequests;
  OfferProviderEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.promoCodeId,
    required this.expiredDatePromo,
    required this.discountPercentage,
    required this.fixedPrice,
    required this.hourlyPrice,
    required this.cancellationFee,
    required this.attributes,
    required this.isFavorite,
    required this.isBusy,
    required this.expertOnline,
    required this.completedRequests,
  });

  @override

  List<Object?> get props => [
    id,
    name,
    image,
    rating,
    promoCodeId,
    expiredDatePromo,
    discountPercentage,
    fixedPrice,
    hourlyPrice,
    cancellationFee,
    attributes,
    isFavorite,
    ratingCount,
    isBusy,
    expertOnline,
    completedRequests
  ];
}

class Attrs {
  final String name;
  final String value;

  Attrs({required this.name, required this.value});

}
