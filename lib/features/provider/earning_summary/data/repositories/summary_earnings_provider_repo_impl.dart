
import 'package:masbar/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/entities/summary_earnings_provider.dart';
import '../../domain/repositories/summary_earnings_provider_repo.dart';
import '../data_source/earnings_summary_provider_data_source.dart';

class SummaryEarningsProviderRepoImpl implements SummaryEarningsProviderRepo {
  final EarningsSummaryDataSource earningsSummaryDataSource;
  SummaryEarningsProviderRepoImpl({
    required this.earningsSummaryDataSource,
  });
  @override
  Future<Either<Failure, SummaryEarningsProviderEntity>>
      getTodaySummary() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await earningsSummaryDataSource.getTodaySummary();
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, SummaryEarningsProviderEntity>> getRangeSummary({required DateTime start, required DateTime end,}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await earningsSummaryDataSource.getRangeSummary(start: start, end: end);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
