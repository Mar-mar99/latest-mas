import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/provider_entity.dart';
import '../repositories/manage_provider_repo.dart';

class SearchActiveProviderUseCase{
final ManageProviderRepo manageProviderRepo;
  SearchActiveProviderUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, List<ProviderEntity>>> call({required String key}) async {
    final res = await manageProviderRepo.searchActiveProviders(key: key);
    return res.fold((l) => Left(l), (info) => Right(info));
  }
}
