// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/user_service_record_repo.dart';

class RateRequestUseCase {
  final UserServiceRecordRepo userServiceRecordRepo;
  RateRequestUseCase({
    required this.userServiceRecordRepo,
  });
  Future<Either<Failure, Unit>> call(
      {required int rating,
      required int requestId,
      String comment = '',
      required bool isFav}) async {
    final res = await userServiceRecordRepo.rate(
      rating: rating,
      requestId: requestId,
      comment: comment,
      isFav: isFav
    );
    return res.fold((l) => Left(l), (_) => Right(unit));
  }
}
