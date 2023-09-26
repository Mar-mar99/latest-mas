import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/payment_method_entity.dart';

abstract class PaymentMethodsRepo {
  Future<Either<Failure,List<PaymentsMethodEntity>>> getPaymentsMethods();
  Future<Either<Failure,Unit>> addCard({required String cardToken});
  Future<Either<Failure,Unit>> setDefaultPaymentMethod({required int cardId});
  Future<Either<Failure,Unit>> deleteCard({required String id});
}
