// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';
import '../repositories/update_profile_repo.dart';

class UpdatePhoneUseCase {
  final UpdateProfileRepo updateProfileRepo;

  UpdatePhoneUseCase({
    required this.updateProfileRepo,

  });

  Future<Either<Failure, Unit>> call({
    required String phone,
    required TypeAuth typeAuth,
  }) async {
    final res = await updateProfileRepo.updateUserPhone(
      phone: phone,
      typeAuth: typeAuth,
    );
  return await res.fold(
      (l) {
        return Left(l);
      },
      (_) async {


            return const Right(unit);

      },
    );
  }
}
