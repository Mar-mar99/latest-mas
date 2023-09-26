import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/services_prices_repo.dart';

class UpdatePriceUseCase {
  final ServicesPricesRepo servicesPricesRepo;
  UpdatePriceUseCase({
    required this.servicesPricesRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int serviceId,
    required int stateId,
    required double fixed,
    required double hourly,
  }) async {
    final res = await servicesPricesRepo.updatePrices(
      serviceId: serviceId,
      stateId: stateId,
      fixed: fixed,
      hourly: hourly,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
