import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../promo_code/domain/repositories/promo_code_repo.dart';
import '../repositories/offers_repo.dart';

class CreateRequestPromoUseCase{
  final OffersRepo offersRepo;
  CreateRequestPromoUseCase({required this.offersRepo});

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
    final res = await offersRepo.requestProviderPromo(state: state,
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
    return res.fold((l) => Left(l), (r) => Right(r));
  }
}
