// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/services/location_service.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class SubmitProviderLocationUseCaase {
  final ProviderRepo providerRepo;
  SubmitProviderLocationUseCaase({
    required this.providerRepo,
  });

  Future<Either<Failure, Unit>> submitProviderLocation() async {
    GeoLoc? location = await LocationService.getLocationCoords();
    if (location != null) {
      final res = await providerRepo.submitProviderLocation(
          lat: location.lat, lng: location.lng);

      return res.fold((l) => Left(l), (_) => Right(unit));
    }
    return Right(unit);
  }
}
