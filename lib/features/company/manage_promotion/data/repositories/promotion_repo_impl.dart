// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/company/manage_promotion/domain/entities/promotion_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../domain/repositories/promotion_repo.dart';
import '../data_source/promotion_data_source.dart';

class PromotionRepoImpl implements PromotionRepo {
  final PromotionDataSource promotionDataSource;
  PromotionRepoImpl({
    required this.promotionDataSource,
  });
  @override
  Future<Either<Failure, Unit>> createPromotionDetails({
    required String promo,
    required num discount,
    required DateTime expiration,
    required List<int> services,
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.createPromotionDetails(
          promo: promo,
          discount: discount,
          expiration: expiration,
          services: services);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> deletePromotionDetails(
      {required int promoId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.deletePromotionDetails(promoId: promoId);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, PromotionEntity>> getPromotionDetails(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.getPromotionDetails(id: id);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<PromotionEntity>>> getPromotions() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.getPromotions();
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> updatePromotionDetails(
      {required int promoId,
      required String promo,
      required num discount,
      required DateTime expiration,
     }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.updatePromotionDetails(
        promoId: promoId,
        promo: promo,
        discount: discount,
        expiration: expiration,
        // services: services,
      );
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure,Unit>> assignServiceToPromo(
      {required int promoId, required int serviceId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.assignServiceToPromo(
          promoId: promoId, serviceId: serviceId);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure,Unit>> removeServiceFromPromo(
      {required int promoId, required int serviceId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await promotionDataSource.removeServiceFromPromo(
          promoId: promoId, serviceId: serviceId);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }
}
