import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/promotion_repo.dart';

class DeletlePromotionUseCase{
   final PromotionRepo promotionRepo;
  DeletlePromotionUseCase({
    required this.promotionRepo,
  });
   Future<Either<Failure,Unit>> call({
    required int promoId,

  })async{
     final res = await promotionRepo.deletePromotionDetails(promoId: promoId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
