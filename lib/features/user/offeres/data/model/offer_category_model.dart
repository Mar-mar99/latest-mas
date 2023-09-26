import '../../domain/entities/offer_category_entity.dart';

class OfferCategoryModel extends OfferCategoryEntity {
  OfferCategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });
  factory OfferCategoryModel.fromJson(Map<String, dynamic> json) {
    return OfferCategoryModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    );
  }
}
