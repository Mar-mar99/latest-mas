import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/payment_methods_repo.dart';

class SetDefaultUseCase {
   final PaymentMethodsRepo paymentMethodsRepo;
  SetDefaultUseCase({
    required this.paymentMethodsRepo,
  });
  Future<Either<Failure, Unit>> call({required int cardId}) async {
    final res = await paymentMethodsRepo.setDefaultPaymentMethod(cardId: cardId);
    return res.fold((l) => Left(l), (r) => Right(unit));
  }
}
