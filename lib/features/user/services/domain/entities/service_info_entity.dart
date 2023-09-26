import 'package:equatable/equatable.dart';

import '../../../../../core/utils/enums/enums.dart';

class ServiceInfoEntity extends Equatable {
  final int? id;
  final String? name;
  final String? nameAr;
  final String? nameUr;
  final String? image;
  final String? basicPrice;
  final String? hourlyPrice;
  final String? textColor;
  final ServicePaymentType? paymentStatus;
  final UserInfoEntity? userInfo;
  final List<ServiceAttributeEntity>? attributes;

  ServiceInfoEntity(
      {this.id,
      this.name,
      this.nameAr,
      this.nameUr,
      this.image,
      this.basicPrice,
      this.hourlyPrice,
      this.textColor,
      this.paymentStatus,
      this.userInfo,
      this.attributes});

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        nameUr,
        image,
        basicPrice,
        hourlyPrice,
        textColor,
        paymentStatus,
        userInfo,
        attributes
      ];
}

class ServiceAttributeEntity extends Equatable {
  final int id;
  final String name;
  final List<String> autoComplete;
  ServiceAttributeEntity({
    required this.id,
    required this.name,
    required this.autoComplete,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        autoComplete,
      ];
}

class UserInfoEntity extends Equatable {
  final double? walletBalance;
  final List<CardsEntity>? cards;
  final List<PromoCodesEntity>? promoCodes;

  UserInfoEntity({this.walletBalance, this.cards, this.promoCodes});

  @override
  List<Object?> get props => [
        walletBalance,
        cards,
        promoCodes,
      ];
}

class CardsEntity extends Equatable {
  final int? id;
  final String? lastFour;
  final String? cardId;
  final String? brand;
  final int? isDefault;

  CardsEntity(
      {this.id, this.lastFour, this.cardId, this.brand, this.isDefault});

  @override
  List<Object?> get props => [
        id,
        lastFour,
        cardId,
        brand,
        isDefault,
      ];
}

class PromoCodesEntity extends Equatable {
 final int? id;
 final String? promoCode;
 final int? discount;

  PromoCodesEntity({this.id, this.promoCode, this.discount,});


  @override

  List<Object?> get props => [
    id, promoCode, discount,
  ];
}
