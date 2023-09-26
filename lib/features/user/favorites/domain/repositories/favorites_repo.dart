import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../entities/favorite_category_entity.dart';
import '../entities/favorite_provider_entity.dart';
import '../entities/favorite_service_entity.dart';

abstract class FavoritesRepo {
Future<Either<Failure,List<FavoriteCategoryEntity>>> getFavoritesCategories();
Future<Either<Failure,List<FavoriteServiceEntity>>> getFavoritesServices({required int id});
Future<Either<Failure,Unit>> saveFavorite({required int providerId});
Future<Either<Failure,Unit>> deleteFavorite({required int providerId});
 Future<Either<Failure,List<FavoriteProviderEntity>>> getFavoritesProviders({required int serviceId,required String lat,
      required String lng});
 Future<Either<Failure,int>> requestProviderFave({
    required int state,
    required double lat,
    required double lng,
    required String address,
    required int serviceType,
    required ServicePaymentType paymentStatus,
     PaymentMethod? paymentMethod,
      required int distance,
    required int providerId,
    List<File>? images,
    DateTime? scheduleDate,
    DateTime? scheduleTime,
    String? notes,
    int? promoCode,
  });

}
