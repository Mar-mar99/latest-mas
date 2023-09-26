// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:masbar/core/api_service/base_api_service.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/extensions/extensions.dart';

import '../../../../../core/api_service/network_service_dio.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../model/promo_code_model.dart';

abstract class PromoCodeDataSource {
  Future<List<PromoCodeModel>> getPromoCode();
  Future<void> addPromoCode({required String promoCode});

}

class PromoCodeDataSourceWithHttp implements PromoCodeDataSource {
  final BaseApiService client;
  PromoCodeDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<void> addPromoCode({required String promoCode}) async {
    await client.postRequest(
        url: ApiConstants.addPromoCodeApi, jsonBody: {"promocode": promoCode});
    return;
  }

  @override
  Future<List<PromoCodeModel>> getPromoCode() async {
    final List<PromoCodeModel> promos = [];
    final res = await client.getRequest(url: ApiConstants.getPromoCodeApi);
    res.forEach((c) {
      promos.add(PromoCodeModel.fromJson(c));
    });
    //  promos.add(PromoCodeModel(promoCodeId: 1234,id: 11,promocode:PromoCodeDetailsEntity(promoCode: '123435') ));
    return promos;
  }

}
