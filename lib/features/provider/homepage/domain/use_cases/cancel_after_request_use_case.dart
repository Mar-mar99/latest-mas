import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class CancelAfterRequestUseCase{
   final ProviderRepo providerRepo;
  CancelAfterRequestUseCase({
    required this.providerRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int id,
    required String reason,
  }) async {
    final res = await providerRepo.cancelAfterAccept(id: id, reason: reason);
    return res.fold((l) => Left(l), (_) => Right(unit));
  }
}
