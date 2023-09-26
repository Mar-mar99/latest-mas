import 'dart:io';

import 'package:masbar/core/utils/extensions/extensions.dart';
import 'package:intl/intl.dart';
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/api_service/network_service_dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../domain/entities/favorite_category_entity.dart';
import '../../domain/entities/favorite_service_entity.dart';
import '../model/favorite_category_model.dart';
import '../model/favorite_service_model.dart';
import '../model/favorite_provider_model.dart';

abstract class FavoritesDataSource {
  Future<List<FavoriteCategoryModel>> getFavoritesCategories();
  Future<List<FavoriteServiceModel>> getFavoritesServices({required int id});
  Future<List<FavoriteProviderModel>> getFavoritesProviders(
      {required int serviceId, required String lat, required String lng});

  Future<void> saveFavorite({required int providerId});
  Future<void> deleteFavorite({required int providerId});
  Future<int> requestProviderFave({
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

class FavoritesDataSourceWithHttp implements FavoritesDataSource {
  final BaseApiService client;
  FavoritesDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<FavoriteCategoryModel>> getFavoritesCategories() async {
    final res = await client.getRequest(url: ApiConstants.favoritesCategories)
        as Map<String, dynamic>;
    List<FavoriteCategoryModel> data = [];
    for (var element in res['List']) {
      data.add(FavoriteCategoryModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<List<FavoriteServiceModel>> getFavoritesServices(
      {required int id}) async {
    final res = await client.getRequest(
        url: ApiConstants.favoritesServices + '/$id') as Map<String, dynamic>;
    List<FavoriteServiceModel> data = [];
    for (var element in res['List']) {
      data.add(FavoriteServiceModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<void> saveFavorite({required int providerId}) async {
    final res = await client.postRequest(
      url: ApiConstants.saveFavorite,
      jsonBody: {'provider_id': providerId},
    );

    return;
  }

  @override
  Future<void> deleteFavorite({required int providerId}) async {
    final res = await client.postRequest(
      url: ApiConstants.removeFavorite,
      jsonBody: {'provider_id': providerId},
    );

    return;
  }
@override
  Future<List<FavoriteProviderModel>> getFavoritesProviders(
      {required int serviceId,
      required String lat,
      required String lng}) async {
    final res = await client.postRequest(
        url: ApiConstants.listFavorites + '/$serviceId',
        jsonBody: {"latitude": lat, "longitude": lng}) as Map<String, dynamic>;
    List<FavoriteProviderModel> data = [];
    for (var element in res['List']) {
      data.add(FavoriteProviderModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<int> requestProviderFave({
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
    final body = {
      "s_latitude": lat,
      "s_longitude": lng,
      's_address': address,
      'service_type': serviceType,
      'distance': distance,
      'payment_mode': (paymentStatus == ServicePaymentType.paid)
          ? paymentMethod!.getText().toUpperCase()
          : "FREE",
      if (scheduleDate != null)
        'schedule_date': DateFormat('yyyy-MM-dd').format(scheduleDate),
      if (scheduleTime != null)
        'schedule_time': DateFormat('kk:mm').format(scheduleTime),
      'state_id': state,
      if (promoCode != null) 'promo_code': promoCode,
      if (notes != null) 'notes': notes,
      "provider_id": providerId
    };

    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final response = await networkServiceDio.multipartRequest(
        url: ApiConstants.requestsService,
        jsonBody: body,
        attributeName: 'images[]',
        files: images);

    return response['request_id'];
  }
}
