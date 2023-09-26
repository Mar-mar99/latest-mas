import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:masbar/core/errors/failures.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import 'package:masbar/features/user/favorites/domain/entities/favorite_service_entity.dart';

import '../../../../../core/api_service/base_repo.dart';
import '../../data/data_source/favorite_data_source.dart';
import '../../domain/entities/favorite_category_entity.dart';
import '../../domain/entities/favorite_provider_entity.dart';
import '../../domain/repositories/favorites_repo.dart';

class FavoritesRepoImpl extends FavoritesRepo {
  final FavoritesDataSource favoritesDataSource;
  FavoritesRepoImpl({
    required this.favoritesDataSource,
  });

  @override
  Future<Either<Failure, List<FavoriteCategoryEntity>>>
      getFavoritesCategories() async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await favoritesDataSource.getFavoritesCategories();
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, List<FavoriteServiceEntity>>> getFavoritesServices(
      {required int id}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await favoritesDataSource.getFavoritesServices(id: id);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Unit>> deleteFavorite(
      {required int providerId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await favoritesDataSource.deleteFavorite(providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> saveFavorite({required int providerId}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await favoritesDataSource.saveFavorite(providerId: providerId);
    });
    return data.fold((f) => Left(f), (data) => Right(unit));
  }

  @override
  Future<Either<Failure, List<FavoriteProviderEntity>>> getFavoritesProviders(
      {required int serviceId,
      required String lat,
      required String lng}) async {
    final data = await BaseRepo.repoRequest(request: () async {
      return await favoritesDataSource.getFavoritesProviders(
          serviceId: serviceId, lat: lat, lng: lng);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }

  @override
  Future<Either<Failure, int>> requestProviderFave({
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
      return await favoritesDataSource.requestProviderFave(
          state: state,
          lat: lat,
          lng: lng,
          address: address,
          serviceType: serviceType,
          paymentStatus: paymentStatus,
          paymentMethod: paymentMethod,
          distance: distance,
          providerId: providerId,
          images: images,
          notes: notes,
          promoCode: promoCode,
          scheduleDate: scheduleDate,
          scheduleTime: scheduleTime);
    });
    return data.fold((f) => Left(f), (data) => Right(data));
  }
}
