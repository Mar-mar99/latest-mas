import 'package:equatable/equatable.dart';

class PromoCodeEntity extends Equatable {
  int? id;
  int? userId;
  int? promoCodeId;
  String? status;
  PromoCodeDetailsEntity? promocode;

  PromoCodeEntity({
    this.id,
    this.userId,
    this.promoCodeId,
    this.status,
    this.promocode,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        promoCodeId,
        status,
        promocode,
      ];
}

class PromoCodeDetailsEntity extends Equatable {
  int? id;
  String? promoCode;
  int? discount;
  String? expiration;
  String? status;
  DateTime? createdBy;

  PromoCodeDetailsEntity(
      {this.id,
      this.promoCode,
      this.discount,
      this.expiration,
      this.status,
      this.createdBy});

  @override
  List<Object?> get props => [
        id,
        promoCode,
        discount,
        expiration,
        status,
        createdBy,
      ];
}
