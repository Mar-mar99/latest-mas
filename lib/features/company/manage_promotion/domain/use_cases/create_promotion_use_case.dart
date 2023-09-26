// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../repositories/promotion_repo.dart';

class CreatePromotionUseCase {
  final PromotionRepo promotionRepo;
  CreatePromotionUseCase({
    required this.promotionRepo,
  });
   Future<Either<Failure,Unit>> call({
    required String promo,
    required num discount,
    required DateTime expiration,
    required List<int> services,
  })async{
     final res = await promotionRepo.createPromotionDetails(promo: promo, discount: discount, expiration: expiration, services: services);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
