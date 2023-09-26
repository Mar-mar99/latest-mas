import 'package:masbar/features/company/manage_promotion/domain/entities/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  PromotionModel(
      {required super.id,
      required super.companyId,
      required super.promo,
      required super.discount,
      required super.expiration,
      required super.status,
      required super.services});
  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      companyId: json['company_id'],
      promo: json['promo_code'],
      discount: json['discount'],
      expiration: DateTime.parse(json['expiration'].toString()),
      status: json['status'],
      services: json['services'] == null
          ? []
          : List<ServicePromotionModel>.from(
              (json["services"] as List<dynamic>).map(
                (x) => ServicePromotionModel.fromJson(
                  x,
                ),
              ),
            ),
    );
  }
}

class ServicePromotionModel extends ServicePromotionEntity {
  ServicePromotionModel(
      {required super.id, required super.name, required super.isAssigned});
  factory ServicePromotionModel.fromJson(Map<String, dynamic> json) {
    return ServicePromotionModel(
      id: json['id'],
      name: json['name'],
      isAssigned: json['assigned'],
    );
  }
}
