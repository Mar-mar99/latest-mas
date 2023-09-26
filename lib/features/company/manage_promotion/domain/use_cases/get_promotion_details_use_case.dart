import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/promotion_entity.dart';
import '../repositories/promotion_repo.dart';

class GetPromotionDetailsUseCase {
  final PromotionRepo promotionRepo;
  GetPromotionDetailsUseCase({
    required this.promotionRepo,
  });
  Future<Either<Failure, PromotionEntity>> call({required int id}) async {
    final res = await promotionRepo.getPromotionDetails(id: id);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
