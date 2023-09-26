// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/favorite_category_entity.dart';

class FavoriteCategoryModel extends FavoriteCategoryEntity {

  FavoriteCategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

   factory FavoriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
