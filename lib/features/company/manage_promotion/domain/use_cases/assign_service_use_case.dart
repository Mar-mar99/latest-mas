// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/promotion_repo.dart';

class AssignServiceUseCase {
  final PromotionRepo promotionRepo;
  AssignServiceUseCase({
    required this.promotionRepo,
  });

  Future<Either<Failure, Unit>> call(
      {required int promoId, required int serviceId}) async {
    final res = await promotionRepo.assignServiceToPromo(
        promoId: promoId, serviceId: serviceId);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
