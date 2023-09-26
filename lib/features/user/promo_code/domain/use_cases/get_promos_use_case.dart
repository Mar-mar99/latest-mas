import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user/promo_code/domain/entities/promo_code_entity.dart';
import 'package:masbar/features/user/promo_code/domain/repositories/promo_code_repo.dart';

class GetPromosUseCase {
  final PromoCodeRepo getPromoCode;
  GetPromosUseCase({required this.getPromoCode});

  Future<Either<Failure, List<PromoCodeEntity>>> call() async {
    final res = await getPromoCode.getPromoCode();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
