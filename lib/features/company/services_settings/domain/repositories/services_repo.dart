import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/cancellation_entity.dart';
import '../entities/company_provider_entity.dart';

import '../entities/service_attribute_entity.dart';

abstract class ServicesRepo {
  Future<Either<Failure, List<CompanyProviderEntity>>> getProviders();
  Future<Either<Failure, List<ServiceAttributeEntity>>> getAttributes({
    required int providerId,
    required int serviceId,
  });

  Future<Either<Failure, Unit>> saveAttributes({
    required List<Map<String, dynamic>> attributes,
  });
   Future<Either<Failure,List<CompanyProviderEntity>>> getServiceAssignedProviders({
    required int serviceId,
  });
   Future<Either<Failure,Unit>> assignProviderToService({
    required int serviceId,
    required int providerId,
  });
  Future<Either<Failure,Unit>> removeProviderFromService({
    required int serviceId,
    required int providerId,
  });
   Future<Either<Failure,CancellationEntity>> getCancellationSettings({
    required int serviceId,
  });
  Future<Either<Failure,Unit>> setCancellationSettings({
    required int serviceId,
    required bool hasCancellationFees,
    required double fees,
  });
}
