import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class SuggestTimeUseCase {
  final ProviderRepo providerRepo;
  SuggestTimeUseCase({
    required this.providerRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required int requestId,
      required DateTime date,
      required DateTime time}) async {
    final res = await providerRepo.suggestAnotherTime(
      requestId: requestId,
      date: date,
      time: time,
    );
    return res.fold((l) => Left(l), (r) => Right(unit));
  }
}
