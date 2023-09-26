import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/provider_info_entity.dart';
import '../repositories/manage_provider_repo.dart';

class InviteProviderUseCase {
  final ManageProviderRepo manageProviderRepo;
  InviteProviderUseCase({
    required this.manageProviderRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String firstName,
    required String lastName,
    required String phone,
    required int state,
  }) async {
    final res = await manageProviderRepo.invite(
      firstname: firstName,
      lastname: lastName,
      mobile: phone,
      state: state,
    );
    return res.fold((l) => Left(l), (info) => Right(info));
  }
}
