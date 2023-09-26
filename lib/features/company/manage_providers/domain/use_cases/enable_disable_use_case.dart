// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/manage_provider_repo.dart';

class EnableDisableUseCase {
  final ManageProviderRepo manageProviderRepo;
  EnableDisableUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required int id, required bool enable}) async {
    if (enable) {
      final res = await manageProviderRepo.enableUser(id: id);
      return res.fold((l) => Left(l), (_) => const Right(unit));
    }else{
       final res = await manageProviderRepo.disableUser(id: id);
      return res.fold((l) => Left(l), (_) => const Right(unit));
    }
  }
}
