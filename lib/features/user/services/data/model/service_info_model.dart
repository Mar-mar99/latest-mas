import '../../../../../core/utils/enums/enums.dart';
import '../../domain/entities/service_info_entity.dart';

class ServiceInfoModel extends ServiceInfoEntity {
  ServiceInfoModel(
      {super.id,
      super.name,
      super.nameAr,
      super.nameUr,
      super.image,
      super.basicPrice,
      super.hourlyPrice,
      super.textColor,
      super.paymentStatus,
      super.userInfo,
      super.attributes});

  factory ServiceInfoModel.fromJson(Map<String, dynamic> json) {
    return ServiceInfoModel(
        id: json['id'],
        name: json['name'],
        nameAr: json['name_ar'],
        nameUr: json['name_ur'],
        image: json['image'],
        basicPrice: json['basic_price'],
        hourlyPrice: json['hourly_price'],
        textColor: json['text_color'],
        paymentStatus: json['payment_status'] == 'paid'
            ? ServicePaymentType.paid
            : ServicePaymentType.free,
        userInfo: json['user_info'] != null
            ? UserInfoModel.fromJson(json['user_info'])
            : null,
        attributes: json["attributes"] != null
            ? List<ServiceAttributeModel>.from(
                (json["attributes"] as List<dynamic>).map(
                  (x) => ServiceAttributeModel.fromJson(
                    x,
                  ),
                ),
              )
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['image'] = image;
    data['basic_price'] = basicPrice;
    data['hourly_price'] = hourlyPrice;
    data['text_color'] = textColor;
    data['payment_status'] = paymentStatus;
    if (userInfo != null) {
      data['user_info'] = (userInfo as UserInfoModel).toJson();
    }
    return data;
  }
}

class ServiceAttributeModel extends ServiceAttributeEntity {
  ServiceAttributeModel({
    required super.id,
    required super.name,
    required super.autoComplete,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'auto_complete': autoComplete,
    };
  }

  factory ServiceAttributeModel.fromJson(Map<String, dynamic> map) {
    return ServiceAttributeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      autoComplete:map['auto_complete']==null?[]: List<String>.from(
        (map['auto_complete'] as List<dynamic>),
      ),
    );
  }
}

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    super.walletBalance,
    super.cards,
    super.promoCodes,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      cards: (json['cards'] != null)
          ? (json['cards'] as List<dynamic>)
              .map((e) => CardsModel.fromJson(e))
              .toList()
          : null,
      walletBalance: double.parse(json['wallet_balance'].toString()),
      promoCodes: json['promo_codes'] != null
          ? (json['promo_codes'] as List<dynamic>)
              .map((e) => PromoCodesModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet_balance'] = walletBalance;
    if (cards != null) {
      data['cards'] = cards!.map((v) => (v as CardsModel).toJson()).toList();
    }
    if (promoCodes != null) {
      data['promo_codes'] =
          promoCodes!.map((v) => (v as PromoCodesModel).toJson()).toList();
    }
    return data;
  }
}

class CardsModel extends CardsEntity {
  CardsModel({
    super.id,
    super.lastFour,
    super.cardId,
    super.brand,
    super.isDefault,
  });

  factory CardsModel.fromJson(Map<String, dynamic> json) {
    return CardsModel(
        id: json['id'],
        lastFour: json['last_four'],
        cardId: json['card_id'],
        brand: json['brand'],
        isDefault: json['is_default']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['last_four'] = lastFour;
    data['card_id'] = cardId;
    data['brand'] = brand;
    data['is_default'] = isDefault;
    return data;
  }
}

class PromoCodesModel extends PromoCodesEntity {
  PromoCodesModel({
    super.id,
    super.promoCode,
    super.discount,
  });

  factory PromoCodesModel.fromJson(Map<String, dynamic> json) {
    return PromoCodesModel(
      id: json['id'],
      promoCode: json['promo_code'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['promo_code'] = promoCode;
    data['discount'] = discount;
    return data;
  }
}
