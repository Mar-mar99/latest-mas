// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/provider/service_records/domain/entities/request_past_provider_entity.dart';
import 'package:masbar/features/provider/service_records/domain/entities/request_upcoming_provider_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/repositories/service_record_provider_repo.dart';
import '../data_source/service_record_provider_data_source.dart';

class ServiceRecordProviderRepoImpl implements ServiceRecordProviderRepo {
  final ServiceRecordeProviderDataSource serviceRecordeProviderDataSource;
  ServiceRecordProviderRepoImpl({
    required this.serviceRecordeProviderDataSource,
  });
  @override
  Future<Either<Failure, List<RequestPastProviderEntity>>>
      getRequestsHistoryProvider({required int page}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await serviceRecordeProviderDataSource.getRequestsHistoryProvider(
          page: page);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<RequestUpcomingProviderEntity>>>
      getRequestsUpcomingProvider({required int page}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await serviceRecordeProviderDataSource.getRequestsUpcomingProvider(
          page: page);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> rate(
      {required int rating,
      required int requestId,
      String comment = ''}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await serviceRecordeProviderDataSource.rate(
          rating: rating, requestId: requestId,comment: comment);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
}
