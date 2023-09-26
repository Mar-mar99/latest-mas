// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/payment_method_entity.dart';
import '../repositories/payment_methods_repo.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodsRepo paymentMethodsRepo;
  GetPaymentMethodsUseCase({
    required this.paymentMethodsRepo,
  });
  Future<Either<Failure, List<PaymentsMethodEntity>>> call() async {
    final res = await paymentMethodsRepo.getPaymentsMethods();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
