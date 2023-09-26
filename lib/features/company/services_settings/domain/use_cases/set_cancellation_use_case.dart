import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/services_repo.dart';

class SetCancellationUseCase{
   final ServicesRepo servicesRepo;
  SetCancellationUseCase({
    required this.servicesRepo,
  });

    Future<Either<Failure,Unit>> call({
    required int serviceId,
    required bool hasCancellationFees,
    required double fees,
  })async{
     final data = await servicesRepo.setCancellationSettings(serviceId: serviceId, hasCancellationFees: hasCancellationFees, fees: fees);
    return data.fold((f) => Left(f), (_) => Right(_));

  }
}
