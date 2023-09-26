// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/my_location_entity.dart';
import '../../domain/repositories/my_locations_repo.dart';
import '../data_source/my_locations_data_source.dart';
import '../model/my_locations_model.dart';

class MyLocationsRepoImpl implements MyLocationsRepo {
  final MyLocationsDataSource myLocationDataSource;
  MyLocationsRepoImpl({
    required this.myLocationDataSource,
  });
  Future<Either<Failure, List<MyLocationsEntity>>> getSavedLocations() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await myLocationDataSource.getSavedLocations();
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> saveLocations(
      {required MyLocationsModel newLocation}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await myLocationDataSource.saveLocations(newLocation: newLocation);
    });
    return data.fold((f) => Left(f), (_) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> deleteLocation({required int id}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await myLocationDataSource.deleteLocation(id: id);
    });
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
