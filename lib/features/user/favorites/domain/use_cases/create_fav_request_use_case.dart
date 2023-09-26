// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../repositories/favorites_repo.dart';

class CreateFavRequestUseCase {
  final FavoritesRepo favoritesRepo;
  CreateFavRequestUseCase({
    required this.favoritesRepo,
  });
Future<Either<Failure,int>> call({
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
    final res = await favoritesRepo.requestProviderFave(
        state: state,
        lat: lat,
        lng: lng,
        address: address,
        serviceType: serviceType,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        providerId: providerId,
        distance: distance,
        images: images,
        notes: notes,
        promoCode: promoCode,
        scheduleDate: scheduleDate,
        scheduleTime: scheduleTime);
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
