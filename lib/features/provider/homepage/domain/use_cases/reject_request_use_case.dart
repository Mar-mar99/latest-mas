import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class RejectRequestUseCase{
  final ProviderRepo providerRepo;
  RejectRequestUseCase({
    required this.providerRepo,
  });
   Future<Either<Failure, Unit>> call(
      {required int requestId}) async {
    final res = await providerRepo.rejectRequest(id: requestId);
    return res.fold((l) => Left(l), (_) => Right(unit));
  }
}
