import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';

abstract class ForgetPasswordRepo{
  Future<Either<Failure,int>> sendEmail({
    required String email,
    required TypeAuth typeAuth,
  });
  Future<Either<Failure,Unit>> submitNewPassword({
    required int id,
    required String password,
    required String confirmPassword,
    required String otp,
    required TypeAuth typeAuth,
  });
}
