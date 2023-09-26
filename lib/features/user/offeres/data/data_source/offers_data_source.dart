// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';

import 'package:intl/intl.dart';
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/api_service/network_service_dio.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../model/offer_category_model.dart';
import '../model/offer_provider_model.dart';
import '../model/offer_service_model.dart';

abstract class OffersDataSource {
  Future<List<OfferCategoryModel>> getPromosCategories();
  Future<List<OfferServiceModel>> getPromosServices({required int id});
  Future<List<OfferProviderModel>> getPromosProviders(
      {required int serviceId, required String keyword});
  Future<int> requestProviderPromo({
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

class OffersDataSourceWithHttp implements OffersDataSource {
  final BaseApiService client;
  OffersDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<OfferCategoryModel>> getPromosCategories() async {
    final res = await client.getRequest(url: ApiConstants.promoCodeCategory)
        as Map<String, dynamic>;
    List<OfferCategoryModel> data = [];
    for (var element in res['List']) {
      data.add(OfferCategoryModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<List<OfferServiceModel>> getPromosServices({required int id}) async {
    final res = await client.getRequest(
        url: ApiConstants.promoCodeServices + '/$id') as Map<String, dynamic>;
    List<OfferServiceModel> data = [];
    for (var element in res['List']) {
      data.add(OfferServiceModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<List<OfferProviderModel>> getPromosProviders(
      {required int serviceId, required String keyword}) async {
    final res = await client.postRequest(
        url: ApiConstants.promoCodeProviders + '/$serviceId',
        jsonBody: {'provider_name': keyword}) as Map<String, dynamic>;
    List<OfferProviderModel> data = [];
    for (var element in res['List']) {
      data.add(OfferProviderModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<int> requestProviderPromo({
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
      if (promoCode != null) 'PromoCodeId': promoCode,
      if (notes != null) 'notes': notes,
      "provider_id": providerId
    };

    NetworkServiceDio networkServiceDio = NetworkServiceDio();

    final response = await networkServiceDio.multipartRequest(
        url: ApiConstants.promoCreateRequest,
        jsonBody: body,
        attributeName: 'images[]',
        files: images);

    return response['request_id'] as int;
  }
}
