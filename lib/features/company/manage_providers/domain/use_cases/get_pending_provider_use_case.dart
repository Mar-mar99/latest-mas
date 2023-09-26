import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_info_entity.dart';
import 'package:masbar/features/company/manage_providers/domain/repositories/manage_provider_repo.dart';
import 'package:masbar/features/company/manage_providers/presentation/screens/manage_providers_screen.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/provider_entity.dart';

class GetPendingProviderUseCase {
  final ManageProviderRepo manageProviderRepo;
  GetPendingProviderUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, List<ProviderEntity>>> call() async {
    final res = await manageProviderRepo.getPending();
    return res.fold((l) => Left(l), (info) => Right(info));
  }
}
