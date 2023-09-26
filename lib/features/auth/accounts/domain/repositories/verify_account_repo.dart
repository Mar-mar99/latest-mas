import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';

abstract class VerifyAccountRepo {
   Future<Either<Failure,Unit>> verifyAccount({required String otp, required TypeAuth auth,});
Future<Either<Failure,Unit>> resendCode({required TypeAuth auth});
}
