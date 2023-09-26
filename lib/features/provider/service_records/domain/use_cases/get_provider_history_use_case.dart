// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/request_past_provider_entity.dart';
import '../repositories/service_record_provider_repo.dart';

class GetProviderHistoryUseCase {
  final ServiceRecordProviderRepo serviceRecordProviderRepo;
  GetProviderHistoryUseCase({
    required this.serviceRecordProviderRepo,
  });

  Future<Either<Failure, List<RequestPastProviderEntity>>> call(
      {required int page}) async {
    final res =
        await serviceRecordProviderRepo.getRequestsHistoryProvider(page: page);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
