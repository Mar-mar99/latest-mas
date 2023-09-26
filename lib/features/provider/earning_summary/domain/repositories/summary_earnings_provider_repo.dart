// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../data/data_source/earnings_summary_provider_data_source.dart';
import '../entities/summary_earnings_provider.dart';

abstract class SummaryEarningsProviderRepo {
  Future<Either<Failure, SummaryEarningsProviderEntity>> getTodaySummary();
 Future< Either<Failure,SummaryEarningsProviderEntity>> getRangeSummary({
    required DateTime start,
    required DateTime end,
  });
}
