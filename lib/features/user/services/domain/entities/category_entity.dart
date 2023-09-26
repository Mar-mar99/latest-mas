import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String image;
  final String title;
  CategoryEntity({
    required this.id,
    required this.image,
    required this.title,
  });

  @override
  List<Object?> get props =>[
    id,
    image,
    title,
  ];
}
