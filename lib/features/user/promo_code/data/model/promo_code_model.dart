import '../../domain/entities/promo_code_entity.dart';

class PromoCodeModel extends PromoCodeEntity {
  PromoCodeModel({
    super.id,
    super.userId,
    super.promoCodeId,
    super.status,
    super.promocode,
  });

  PromoCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    promoCodeId = json['promocode_id'];
    status = json['status'];
    promocode = json['promocode'] != null
        ? PromoCodeDetailsModel.fromJson(json['promocode'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['promocode_id'] = promoCodeId;
    data['status'] = status;
    if (promocode != null) {
      data['promocode'] = (promocode! as PromoCodeDetailsModel).toJson();
    }
    return data;
  }
}

class PromoCodeDetailsModel extends PromoCodeDetailsEntity {
  PromoCodeDetailsModel(
      {super.id,
      super.promoCode,
      super.discount,
      super.expiration,
      super.status,
      super.createdBy});

  PromoCodeDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promoCode = json['promo_code'];
    discount = json['discount'];
    expiration = json['expiration'];
    status = json['status'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['promo_code'] = promoCode;
    data['discount'] = discount;
    data['expiration'] = expiration;
    data['status'] = status;
    data['created_by'] = createdBy;
    return data;
  }
}
