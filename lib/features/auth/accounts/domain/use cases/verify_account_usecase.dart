// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../repositories/auth_repo.dart';
import '../repositories/verify_account_repo.dart';

class VerifyAccountUsecase {
  final VerifyAccountRepo verifyAccountRepo;
  final AuthRepo authRepo;
  VerifyAccountUsecase({
    required this.verifyAccountRepo,
    required this.authRepo,
  });

  Future<Either<Failure, Unit>> call({
    required String otp,
  }) async {
    final res = await verifyAccountRepo.verifyAccount(
      otp: otp,
      auth: Helpers.getUserTypeEnum(
        authRepo.getUserData()!.type!,
      ),

    );
    print('done verifying');
    return await res.fold(
      (f) {
        return Left(f);
      },
      (id) async {
        print('updating verified status');
       await authRepo.updateVerifiedState();
        return const Right(unit);
      },
    );
  }
}
