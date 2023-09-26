// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/company/services_prices/domain/entities/services_prices_entity.dart';
import 'package:masbar/features/company/services_prices/domain/repositories/services_prices_repo.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../data_source/service_prices_data_source.dart';

class ServicesPricesRepoImpl extends ServicesPricesRepo {
  final ServicePricesDataSource servicePricesDataSource;
  ServicesPricesRepoImpl({
    required this.servicePricesDataSource,
  });



  @override
  Future<Either<Failure, List<ServicePriceEntity>>> getPrices(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicePricesDataSource.getPrices(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> updatePrices({
    required int serviceId,
    required int stateId,
    required double fixed,
    required double hourly,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicePricesDataSource.updatePrices(serviceId: serviceId, stateId: stateId, fixed: fixed, hourly: hourly);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
}
