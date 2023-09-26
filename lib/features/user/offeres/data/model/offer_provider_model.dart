import '../../domain/entities/offer_provider_entity.dart';

class OfferProviderModel extends OfferProviderEntity {
  OfferProviderModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.rating,
      required super.promoCodeId,
      required super.expiredDatePromo,
      required super.discountPercentage,
      required super.fixedPrice,
      required super.hourlyPrice,
      required super.cancellationFee,
      required super.attributes,
      required super.isFavorite,
      required super.ratingCount,
      required super.isBusy,
      required super.expertOnline,
      required super.completedRequests});

  factory OfferProviderModel.fromJson(Map<String, dynamic> json) {
    return OfferProviderModel(
      id: json['id'],
      name: json['name'],
      image: json['avatar'] ?? '',
      rating: json['rating'],
      promoCodeId: json['PromoCodeId'],
      expiredDatePromo: DateTime.parse(json['PromoCodeExpiryDate']),
      discountPercentage: json['DiscountPercentage'],
      fixedPrice: json['fixed_price'],
      hourlyPrice: json['hourly_price'],
      cancellationFee:
          json['cancelation_fees'] == '0.00' ? '0' : json['cancelation_fees'],
      attributes: json['attrs'] != null
          ? List.from((json['attrs']) as List)
              .map(
                (e) => AttrsModel.fromJson(
                  e,
                ),
              )
              .toList()
          : [],
      isFavorite: json['isFavourite'],
      ratingCount: json['rating_count'],
      expertOnline: json['expertOnline'] == 'No' ? false : true,
      isBusy: json['isBusy'] == 0 ? false : true,
      completedRequests: json['CompletedRequests'],
    );
  }
}

class AttrsModel extends Attrs {
  AttrsModel({required super.name, required super.value});
  factory AttrsModel.fromJson(Map<String, dynamic> json) {
    return AttrsModel(name: json['name'] ?? '', value: json['value'] ?? '');
  }
}
