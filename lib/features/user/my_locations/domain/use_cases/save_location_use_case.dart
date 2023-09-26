import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/my_locations_model.dart';
import '../repositories/my_locations_repo.dart';

class SaveLocationUseCase{
 final MyLocationsRepo myLocationsRepo;
  SaveLocationUseCase({
    required this.myLocationsRepo,
  });
  Future<Either<Failure, Unit>> call({required MyLocationsModel newLocation}) async {
    final res = await myLocationsRepo.saveLocations(newLocation: newLocation);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
