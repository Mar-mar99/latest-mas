// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/summary_earnings_provider.dart';
import '../repositories/summary_earnings_provider_repo.dart';

class GetRangeSummaryProviderUseCase {
  final SummaryEarningsProviderRepo summaryEarningsProviderRepo;
  GetRangeSummaryProviderUseCase({
    required this.summaryEarningsProviderRepo,
  });
  Future<Either<Failure, SummaryEarningsProviderEntity>> call({
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await summaryEarningsProviderRepo.getRangeSummary(
        start: start, end: end);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
