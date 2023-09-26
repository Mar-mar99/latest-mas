// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/services_prices_entity.dart';

class ServicePriceModel extends ServicePriceEntity {
  ServicePriceModel(
      {required super.stateid,
      required super.stateName,
      required super.fixedPrice,
      required super.hourlyPrice});
  factory ServicePriceModel.fromJson(Map<String, dynamic> json) {
    return ServicePriceModel(
      fixedPrice: json['fixed_price'] ,
      hourlyPrice: json['hourly_price'],
      stateName: json['StateName'],
      stateid: json['StateId'],
    );
  }
}
