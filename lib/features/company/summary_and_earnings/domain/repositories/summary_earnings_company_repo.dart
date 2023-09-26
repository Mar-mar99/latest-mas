// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';

import '../entities/summary_earnings_company.dart';


abstract class SummaryEarningsCompanyRepo {
  Future<Either<Failure, SummaryEarningsCompanyEntity>> getTodaySummary({
    required
      String? providerId});
 Future< Either<Failure,SummaryEarningsCompanyEntity>> getRangeSummary({
    required DateTime start,
    required DateTime end,
     String ? providerId
  });
}
