// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';


import '../entities/favorite_service_entity.dart';
import '../repositories/favorites_repo.dart';

class GetFavServicesUseCase {
  final FavoritesRepo favoritesRepo;
  GetFavServicesUseCase({
    required this.favoritesRepo,
  });

Future<Either<Failure,List<FavoriteServiceEntity>>> call({required int id})async{
    final res = await favoritesRepo.getFavoritesServices(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
