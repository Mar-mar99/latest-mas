// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/my_location_entity.dart';
import '../repositories/my_locations_repo.dart';

class GetSavedLocationsUseCase {
  final MyLocationsRepo myLocationsRepo;
  GetSavedLocationsUseCase({
    required this.myLocationsRepo,
  });
  Future<Either<Failure, List<MyLocationsEntity>>> call() async {
    final res = await myLocationsRepo.getSavedLocations();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
