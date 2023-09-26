import '../../domain/entities/service_provider_entity.dart';

class ServiceProviderModel extends ServiceProviderEntity {
  ServiceProviderModel(
      {required super.distance,
      required super.id,
      required super.companyId,
      required super.firstName,
      required super.lastName,
      required super.name,
      required super.email,
      required super.phoneCode,
      required super.mobile,
      required super.avatar,
      required super.description,
      required super.rating,
      required super.status,
      required super.latitude,
      required super.longitude,
      required super.ratingCount,
      required super.otp,
      required super.verified,
      required super.stripeAccId,
      required super.isStripeinfoFilled,
      required super.isStripeConnected,
      required super.type,
      required super.providersCount,
      required super.commission,
      required super.local,
      required super.address,
      required super.expertActive,
      required super.expertOnline,
      required super.isBusy,
      required super.hideFormList,
      required super.stateId,
      required super.fixedPrice,
      required super.hourlyPrice,
      required super.completedRequests,
      required super.attrs,
      required super.isFavourite,
      required super.isNew, required super.cancelationFees});

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      distance: json['distance'] ?? 0,
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneCode: json['phone_code'] ?? '',
      mobile: json['mobile'] ?? '',
      avatar: json['avatar'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] ?? '',
      status: json['status'] ?? '',
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      ratingCount: json['rating_count'] ?? 0,
      otp: json['otp'] ?? 0,
      verified: json['verified'] ?? 0,
      stripeAccId: json['stripe_acc_id'],
      isStripeinfoFilled: json['is_stripeinfo_filled'] ?? 0,
      isStripeConnected: json['is_stripe_connected'] ?? 0,
      type: json['type'] ?? '',
      providersCount: json['providers_count'] ?? 0,
      commission: json['commission'],
      local: json['local'],
      address: json['address'] ?? '',
      expertActive: json['expertActive'] ?? '',
      expertOnline: json['expertOnline'] ?? '',
      isBusy: json['isBusy'] ?? 0,
      hideFormList: json['hide_form_list'] ?? 0,
      stateId: json['state_id'] ?? 0,
      fixedPrice: json['fixed_price'] ?? '',
      hourlyPrice: json['hourly_price'] ?? '',
      completedRequests: json['CompletedRequests'] ?? 0,
      attrs: json['attrs'] != null
          ? List.from((json['attrs']) as List)
              .map(
                (e) => AttrsModel.fromJson(
                  e,
                ),
              )
              .toList()
          : [],
      isFavourite: json['isFavourite'] ?? false,
      isNew: json['isNew'] ?? false,
      cancelationFees: json['cancelation_fees']=='0.00'?'0':json['cancelation_fees'].toString()
    );
  }
}

class AttrsModel extends Attrs {
  AttrsModel({required super.name, required super.value});
  factory AttrsModel.fromJson(Map<String, dynamic> json) {
    return AttrsModel(name: json['name'] ?? '', value: json['value'] ?? '');
  }
}
