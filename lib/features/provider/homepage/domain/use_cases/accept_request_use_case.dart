// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/provider_repo.dart';

class AcceptRequestUseCase {
  final ProviderRepo providerRepo;
  AcceptRequestUseCase({
    required this.providerRepo,
  });
   Future<Either<Failure, Unit>> call(
      {required int requestId}) async {
    final res = await providerRepo.acceptRequest(id: requestId);
    return res.fold((l) => Left(l), (_) => Right(unit));
  }
}
