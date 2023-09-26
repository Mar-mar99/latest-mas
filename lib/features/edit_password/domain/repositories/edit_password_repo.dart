import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';

abstract class EditPasswordRepo {
  Future<Either<Failure, Unit>> updatePassword(
      {required String oldPassword,
      required String password,
      required String passwordConfirmation,
      required TypeAuth typeAuth});
}
