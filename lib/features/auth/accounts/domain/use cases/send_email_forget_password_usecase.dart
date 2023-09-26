// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../repositories/forget_password_repo.dart';

class SendEmailForgetPasswordUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;
  SendEmailForgetPasswordUseCase({
    required this.forgetPasswordRepo,
  });
  Future<Either<Failure, int>> call({
    required String email,
    required TypeAuth typeAuth,
  }) async {
    final res =
        await forgetPasswordRepo.sendEmail(email: email, typeAuth: typeAuth);
    return res.fold(
      (f) {
        return Left(f);
      },
      (id) async {
        return  Right(id);
      },
    );
  }
}
