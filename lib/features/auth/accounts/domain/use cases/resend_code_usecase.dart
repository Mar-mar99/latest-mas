import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/helpers.dart';
import '../repositories/auth_repo.dart';
import '../repositories/verify_account_repo.dart';

class ResendCodeUsecase {
  final VerifyAccountRepo verifyAccountRepo;
  final AuthRepo authRepo;
  ResendCodeUsecase({required this.verifyAccountRepo, required this.authRepo});

  Future<Either<Failure, Unit>> call() async {
    final res = await verifyAccountRepo.resendCode(
      auth: Helpers.getUserTypeEnum(
        authRepo.getUserData()!.type!,
      ),

    );
    return res.fold(
      (f) {
        return Left(f);
      },
      (id) async {
        return const Right(unit);
      },
    );
  }
}
