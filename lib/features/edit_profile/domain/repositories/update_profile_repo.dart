import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';

abstract class UpdateProfileRepo {
  Future<Either<Failure, Unit>> updateUserProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  });
  Future<Either<Failure, Unit>> updateCompanyProfile({
    required String firstName,
    required String address,
    required int local,
    required int state,
    File? avatar,
  });
  Future<Either<Failure, Unit>> updateProviderProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  });
  Future<Either<Failure, Unit>> updateUserPhone({
    required String phone,
    required TypeAuth typeAuth,
  });
  Future<Either<Failure, Unit>> verifyUserPhone({
    required String phone,
    required TypeAuth typeAuth,
    required String phoneCode,
  });
}
