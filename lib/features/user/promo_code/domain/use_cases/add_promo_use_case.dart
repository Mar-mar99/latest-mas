import 'package:dartz/dartz.dart';
import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user/promo_code/domain/repositories/promo_code_repo.dart';

class AddPromoUseCase{
   final PromoCodeRepo getPromoCode;
  AddPromoUseCase({required this.getPromoCode});

  Future<Either<Failure, Unit>> call({required String promoCode}) async {
    final res = await getPromoCode.addPromoCode(promoCode: promoCode);
    return res.fold((l) => Left(l), (r) => Right(unit));
  }
}
