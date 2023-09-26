// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/summary_earnings_company.dart';
import '../repositories/summary_earnings_company_repo.dart';

class GetRangeSummaryCompanyUseCase {
  final SummaryEarningsCompanyRepo summaryEarningsCompanyRepo;
  GetRangeSummaryCompanyUseCase({
    required this.summaryEarningsCompanyRepo,
  });
  Future<Either<Failure, SummaryEarningsCompanyEntity>> call({
    required DateTime start,
    required DateTime end,
    String? providerId,
  }) async {
    final res = await summaryEarningsCompanyRepo.getRangeSummary(
        start: start, end: end, providerId: providerId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
