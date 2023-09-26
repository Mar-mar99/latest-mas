// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/services/location_service.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/favorite_provider_entity.dart';
import '../entities/favorite_service_entity.dart';
import '../repositories/favorites_repo.dart';

class GetFavListUseCase {
  final FavoritesRepo favoritesRepo;
  GetFavListUseCase({
    required this.favoritesRepo,
  });

  Future<Either<Failure, List<FavoriteProviderEntity>>> call({
    required int serviceId,
  }) async {
    GeoLoc? loc = await LocationService.getLocationCoords();
    if (loc != null) {
      final res = await favoritesRepo.getFavoritesProviders(
        serviceId: serviceId,
        lat: loc.lat.toString(),
        lng: loc.lng.toString(),
      );
      return res.fold((l) => Left(l), (r) => Right(r));
    }else{
      return Left(NetworkErrorFailure(message: 'Error fetching Coordinates'));
    }
  }
}
