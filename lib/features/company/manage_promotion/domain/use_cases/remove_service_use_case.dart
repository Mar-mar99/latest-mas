import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/promotion_repo.dart';

class RemoveServiceUseCase {
  final PromotionRepo promotionRepo;
  RemoveServiceUseCase({
    required this.promotionRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required int promoId, required int serviceId}) async {
    final res = await promotionRepo.removeServiceFromPromo(
        promoId: promoId, serviceId: serviceId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
