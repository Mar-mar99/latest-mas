// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/promotion_repo.dart';

class UpdatePromotionUseCase {
  final PromotionRepo promotionRepo;
  UpdatePromotionUseCase({
    required this.promotionRepo,
  });
  Future<Either<Failure, Unit>> call({
    required int promoId,
    required String promo,
    required num discount,
    required DateTime expiration,

  }) async {
    final res = await promotionRepo.updatePromotionDetails(
      promoId: promoId,
      promo: promo,
      discount: discount,
      expiration: expiration,
      // services: services,
    );
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
