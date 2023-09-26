// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/favorite_category_entity.dart';
import '../repositories/favorites_repo.dart';

class GetFavCategoriesUseCase {
  final FavoritesRepo favoritesRepo;
  GetFavCategoriesUseCase({
    required this.favoritesRepo,
  });

Future<Either<Failure,List<FavoriteCategoryEntity>>> call()async{
    final res = await favoritesRepo.getFavoritesCategories();
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
