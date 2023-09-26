// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user/payment_methods/domain/entities/payment_method_entity.dart';
import 'package:masbar/features/user/payment_methods/domain/repositories/payment_methods_repo.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../data_source/payment_data_source.dart';

class PaymentMethodsRepoImpl implements PaymentMethodsRepo {
  final PaymentDataSource paymentDataSource;
  PaymentMethodsRepoImpl({
    required this.paymentDataSource,
  });

  @override
  Future<Either<Failure, List<PaymentsMethodEntity>>>
      getPaymentsMethods() async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await paymentDataSource.getPaymentsMethods();
      },
    );
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> addCard({required String cardToken}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await paymentDataSource.addCard(cardToken: cardToken);
      },
    );
    return data.fold((f) => Left(f), (data) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> deleteCard({required String id}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await paymentDataSource.deleteCard(id: id);
      },
    );
    return data.fold((f) => Left(f), (data) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> setDefaultPaymentMethod(
      {required int cardId}) async {
    final data = await BaseRepo.repoRequest(
      request: () async {
        return await paymentDataSource.setDefaultPaymentMethod(cardId: cardId);
      },
    );
    return data.fold((f) => Left(f), (data) => const Right(unit));
  }
}
