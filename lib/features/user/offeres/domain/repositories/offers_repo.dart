import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:masbar/features/user/offeres/domain/entities/offer_category_entity.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../entities/offer_provider_entity.dart';
import '../entities/offer_service_entity.dart';

abstract class OffersRepo{
  Future<Either<Failure,List<OfferCategoryEntity>>> getPromosCategories();
  Future<Either<Failure,List<OfferServiceEntity>>> getPromosServices({required int id});
   Future<Either<Failure,List<OfferProviderEntity>>> getPromosProviders(
      {required int serviceId, required String keyword});
  Future<Either<Failure,int>> requestProviderPromo({
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
  });
}
