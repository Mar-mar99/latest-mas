// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/features/company/services_settings/data/model/service_attribute_model.dart';
import 'package:masbar/features/company/services_settings/domain/entities/cancellation_entity.dart';
import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/company_provider_entity.dart';

import '../../domain/entities/service_attribute_entity.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../domain/entities/service_attribute_entity.dart';
import '../../domain/repositories/services_repo.dart';
import '../data_sources/services_remote_data_source.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesRemoteDataSource servicesRemoteDataSource;

  ServicesRepoImpl({
    required this.servicesRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<ServiceAttributeEntity>>> getAttributes({
    required int providerId,
    required int serviceId,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.getAttributes(
            providerId: providerId, serviceId: serviceId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<CompanyProviderEntity>>> getProviders() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.getProviders();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> saveAttributes({
    required List<Map<String, dynamic>> attributes,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.saveAttributes(
            attributes: attributes);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, List<CompanyProviderEntity>>>
      getServiceAssignedProviders({required int serviceId}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.getServiceAssignedProviders(
            serviceId: serviceId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> assignProviderToService({
    required int serviceId,
    required int providerId,
  }) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.assignProviderToService(serviceId: serviceId, providerId: providerId);
      },
    );
    return data.fold((f) => Left(f), (_) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> removeProviderFromService(
      {required int serviceId, required int providerId}) async{
   final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.removeProviderFromService(serviceId: serviceId, providerId: providerId);
      },
    );
    return data.fold((f) => Left(f), (_) => Right(unit));
  }

  @override
  Future<Either<Failure, CancellationEntity>> getCancellationSettings({required int serviceId}) async{
     final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.getCancellationSettings(serviceId: serviceId);
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> setCancellationSettings({required int serviceId, required bool hasCancellationFees, required double fees})async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await servicesRemoteDataSource.setCancellationSettings(serviceId: serviceId, hasCancellationFees: hasCancellationFees, fees: fees);
      },
    );
    return data.fold((f) => Left(f), (_) => Right(unit));
  }
}
