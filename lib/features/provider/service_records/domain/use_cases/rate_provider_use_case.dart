// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/service_record_provider_repo.dart';

class RateProviderUseCase {
  final ServiceRecordProviderRepo serviceRecordProviderRepo;
  RateProviderUseCase({
    required this.serviceRecordProviderRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int rating,
    required int requestId,
    String comment = '',
  }) async {
    final res = await serviceRecordProviderRepo.rate(
      rating: rating,
      requestId: requestId,
      comment: comment,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
