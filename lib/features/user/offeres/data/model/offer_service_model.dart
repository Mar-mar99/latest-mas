import 'package:masbar/features/user/offeres/domain/entities/offer_service_entity.dart';

class OfferServiceModel extends OfferServiceEntity{
  OfferServiceModel({required super.id, required super.name, required super.image});
 factory OfferServiceModel.fromJson(Map<String, dynamic> json) {
    return OfferServiceModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    );
  }
}
