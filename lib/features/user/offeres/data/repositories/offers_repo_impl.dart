import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/features/user/offeres/domain/entities/offer_category_entity.dart';
import 'package:masbar/features/user/offeres/domain/entities/offer_provider_entity.dart';
import 'package:masbar/features/user/offeres/domain/entities/offer_service_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../domain/repositories/offers_repo.dart';
import '../data_source/offers_data_source.dart';

class OffersRepoImpl implements OffersRepo {
  final OffersDataSource offersDataSource;
  OffersRepoImpl({
    required this.offersDataSource,
  });
  @override
  Future<Either<Failure, List<OfferCategoryEntity>>>
      getPromosCategories() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await offersDataSource.getPromosCategories();
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<OfferServiceEntity>>> getPromosServices(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await offersDataSource.getPromosServices(id: id);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<OfferProviderEntity>>> getPromosProviders(
      {required int serviceId, required String keyword}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await offersDataSource.getPromosProviders(
          serviceId: serviceId, keyword: keyword);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, int>> requestProviderPromo({
    required int state,
    required double lat,
    required double lng,
    required String address,
    required int serviceType,
    required ServicePaymentType paymentStatus,
    PaymentMethod? paymentMethod,
    required int providerId,
    required int distance,
    List<File>? images,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
    String? notes,
    int? promoCode,
  }) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await offersDataSource.requestProviderPromo(
          state: state,
          lat: lat,
          lng: lng,
          address: address,
          serviceType: serviceType,
          paymentStatus: paymentStatus,
          providerId: providerId,
          distance: distance,
          images: images,
          notes: notes,
          paymentMethod: paymentMethod,
          promoCode: promoCode,
          scheduleDate: scheduleDate,
          scheduleTime: scheduleTime);
    });
    return data.fold((f) => Left(f), (id) => Right(id));
  }
}
