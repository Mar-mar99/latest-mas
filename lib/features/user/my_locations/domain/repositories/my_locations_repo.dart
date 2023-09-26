import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/model/my_locations_model.dart';
import '../entities/my_location_entity.dart';

abstract class MyLocationsRepo{
  Future<Either<Failure,List<MyLocationsEntity>>> getSavedLocations();
   Future<Either<Failure,Unit>> saveLocations({required MyLocationsModel newLocation});
     Future<Either<Failure,Unit>> deleteLocation({required int id});
}
