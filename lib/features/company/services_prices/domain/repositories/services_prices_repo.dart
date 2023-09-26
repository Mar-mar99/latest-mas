import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/services_prices_entity.dart';

abstract class ServicesPricesRepo {

  Future<Either<Failure, List<ServicePriceEntity>>> getPrices(
      {required int id});
  Future<Either<Failure, Unit>> updatePrices({
    required int serviceId,
    required int stateId,
    required double fixed,
    required double hourly,
  });
}
