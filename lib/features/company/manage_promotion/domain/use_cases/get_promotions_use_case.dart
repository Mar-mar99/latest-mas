import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/promotion_entity.dart';
import '../repositories/promotion_repo.dart';

class GetPromotionsUseCase {
  final PromotionRepo promotionRepo;
  GetPromotionsUseCase({
    required this.promotionRepo,
  });
  Future<Either<Failure, List<PromotionEntity>>> call() async {
    final res = await promotionRepo.getPromotions();
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
