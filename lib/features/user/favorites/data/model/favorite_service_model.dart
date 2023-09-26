import '../../domain/entities/favorite_service_entity.dart';

class FavoriteServiceModel extends FavoriteServiceEntity {
  FavoriteServiceModel({
    required super.id,
    required super.name,
    required super.image,
  });
  factory FavoriteServiceModel.fromJson(Map<String, dynamic> json) {
    return FavoriteServiceModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
