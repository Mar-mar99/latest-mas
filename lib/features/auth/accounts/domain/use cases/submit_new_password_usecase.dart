import 'package:dartz/dartz.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/features/auth/accounts/domain/repositories/forget_password_repo.dart';

import '../../../../../core/errors/failures.dart';

class SubmitNewPasswordUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;
  SubmitNewPasswordUseCase({
    required this.forgetPasswordRepo,
  });
  Future<Either<Failure, Unit>> call({
    required int id,
    required String password,
    required String confirmPassword,
    required String otp,
    required TypeAuth typeAuth,
  }) async {
    final res = await forgetPasswordRepo.submitNewPassword(
        id: id,
        password: password,
        confirmPassword: confirmPassword,
        otp: otp,
        typeAuth: typeAuth);
    return res.fold(
      (f) {
        print('f $f');
        return Left(f);
      },
      (id) async {
        return const Right(unit);
      },
    );
  }
}
