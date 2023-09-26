// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/my_location_entity.dart';
import '../repositories/my_locations_repo.dart';

class DeleteLocationsUseCase {
  final MyLocationsRepo myLocationsRepo;
  DeleteLocationsUseCase({
    required this.myLocationsRepo,
  });
  Future<Either<Failure, Unit>> call({required int id}) async {
    final res = await myLocationsRepo.deleteLocation(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
