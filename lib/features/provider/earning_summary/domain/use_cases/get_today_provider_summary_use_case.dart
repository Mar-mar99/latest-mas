// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/summary_earnings_provider.dart';
import '../repositories/summary_earnings_provider_repo.dart';

class GetTodayProviderUseCase {
  final SummaryEarningsProviderRepo summaryEarningsProviderRepo;
  GetTodayProviderUseCase({
    required this.summaryEarningsProviderRepo,
  });
  Future<Either<Failure, SummaryEarningsProviderEntity>> call() async {
    final res = await summaryEarningsProviderRepo.getTodaySummary();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
