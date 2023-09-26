import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/promotion_entity.dart';

abstract class PromotionRepo {
  Future<Either<Failure,List<PromotionEntity>>> getPromotions();
  Future<Either<Failure,PromotionEntity>> getPromotionDetails({required int id});
  Future<Either<Failure,Unit>> createPromotionDetails({
    required String promo,
    required num discount,
    required DateTime expiration,
    required List<int> services,
  });
  Future<Either<Failure,Unit>> updatePromotionDetails({
    required int promoId,
    required String promo,
    required num discount,
    required DateTime expiration,
  
  });
  Future<Either<Failure,Unit>> deletePromotionDetails({
    required int promoId,
  });
    Future<Either<Failure,Unit>> assignServiceToPromo({
    required int promoId,
    required int serviceId,
  });
  Future<Either<Failure,Unit>> removeServiceFromPromo({
    required int promoId,
    required int serviceId,
  });
}
