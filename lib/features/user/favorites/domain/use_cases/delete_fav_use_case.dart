// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';


import '../entities/favorite_service_entity.dart';
import '../repositories/favorites_repo.dart';

class DeleteFavServicesUseCase {
  final FavoritesRepo favoritesRepo;
  DeleteFavServicesUseCase({
    required this.favoritesRepo,
  });

Future<Either<Failure,Unit>> call({required int providerId})async{
    final res = await favoritesRepo.deleteFavorite(providerId: providerId);
    return res.fold((l) => Left(l), (r) => Right(r));
}
}
