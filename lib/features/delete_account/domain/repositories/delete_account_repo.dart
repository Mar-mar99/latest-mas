import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums/enums.dart';

abstract class DeleteAccountRepo {
 Future<Either<Failure,Unit>> deleteAccount({required TypeAuth typeAuth});
}
