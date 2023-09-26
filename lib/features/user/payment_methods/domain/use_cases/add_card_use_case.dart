// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/features/user/payment_methods/domain/repositories/payment_methods_repo.dart';

import '../../../../../core/errors/failures.dart';

class AddCardUseCase {
  final PaymentMethodsRepo paymentMethodsRepo;
  AddCardUseCase({
    required this.paymentMethodsRepo,
  });
  Future<Either<Failure, Unit>> call({required String cardToken}) async {
    final res = await paymentMethodsRepo.addCard(cardToken: cardToken);
    return res.fold((l) => Left(l), (r) => const Right(unit));
  }
}
