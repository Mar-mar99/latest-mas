import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/offline_request_entity.dart';
import '../repositories/provider_repo.dart';

class FetchOfflineRequestUseCase{
  final ProviderRepo providerRepo;
  FetchOfflineRequestUseCase({
    required this.providerRepo,
  });

   Future<Either<Failure,List<OfflineRequestEntity>>> call() async {
    final res = await providerRepo.fetchOfflineRequests();
    return res.fold((l) => Left(l), (data) => Right(data));
  }
}

