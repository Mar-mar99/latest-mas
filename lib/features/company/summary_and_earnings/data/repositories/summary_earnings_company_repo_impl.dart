
import 'package:masbar/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/summary_earnings_company.dart';
import '../../domain/repositories/summary_earnings_company_repo.dart';

import '../data_source/earnings_summary_provider_data_source.dart';

class SummaryEarningsCompanyRepoImpl implements SummaryEarningsCompanyRepo {
  final CompanyEarningsSummaryDataSource earningsSummaryDataSource;
  SummaryEarningsCompanyRepoImpl({
    required this.earningsSummaryDataSource,
  });
  @override
  Future<Either<Failure, SummaryEarningsCompanyEntity>>
      getTodaySummary({
    required
      String? providerId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await earningsSummaryDataSource.getTodaySummary(providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, SummaryEarningsCompanyEntity>> getRangeSummary({
    required DateTime start,
    required DateTime end,
    String ? providerId
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await earningsSummaryDataSource.getRangeSummary(
          start: start, end: end,providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
