import 'package:dartz/dartz.dart';

import 'package:masbar/features/user/payment_methods/domain/repositories/payment_methods_repo.dart';

import '../../../../../core/errors/failures.dart';

class DeleteCardUseCase {
  final PaymentMethodsRepo paymentMethodsRepo;
  DeleteCardUseCase({
    required this.paymentMethodsRepo,
  });
  Future<Either<Failure, Unit>> call({required String id}) async {
    final res = await paymentMethodsRepo.deleteCard(id: id);
    return res.fold((l) => Left(l), (r) => const Right(unit));
  }
}
