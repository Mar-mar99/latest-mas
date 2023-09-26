
import 'package:equatable/equatable.dart';

class PromotionEntity extends Equatable {
 final int id;
 final int companyId;
 final String promo;
 final num discount;
 final DateTime expiration;
 final String status;
 final List<ServicePromotionEntity> services;
  PromotionEntity({
    required this.id,
    required this.companyId,
    required this.promo,
    required this.discount,
    required this.expiration,
    required this.status,
    required this.services,
  });

  @override

  List<Object?> get props =>[
    id,
    companyId,
    services,
    promo,
    discount,
    expiration,
    status,
  ];
}
class ServicePromotionEntity extends Equatable {
  final int id;
  final String name;
   final bool isAssigned;
  ServicePromotionEntity({
    required this.id,
    required this.name,
    required this.isAssigned,
  });

  @override

  List<Object?> get props => [
    id,
    name,
    isAssigned,
  ];

}
