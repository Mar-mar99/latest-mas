import 'package:dartz/dartz.dart';
import 'package:masbar/features/company/manage_providers/domain/repositories/manage_provider_repo.dart';

import '../../../../../core/errors/failures.dart';

class DeleteInvitationUseCase {
  final ManageProviderRepo manageProviderRepo;
  DeleteInvitationUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, Unit>> call({
    required int id,
  }) async {
    final res = await manageProviderRepo.deleteInvitation(id: id);
    return res.fold((l) => Left(l), (_) => const Right(unit));
  }
}
