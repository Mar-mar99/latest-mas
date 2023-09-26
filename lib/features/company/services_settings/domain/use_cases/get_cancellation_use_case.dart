// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/cancellation_entity.dart';
import '../repositories/services_repo.dart';

class GetCancellationUseCase {
  final ServicesRepo servicesRepo;
  GetCancellationUseCase({
    required this.servicesRepo,
  });

    Future<Either<Failure,CancellationEntity>> call({
    required int serviceId,
  })async{
     final data = await servicesRepo.getCancellationSettings(serviceId: serviceId);
    return data.fold((f) => Left(f), (data) => Right(data));

  }
}
