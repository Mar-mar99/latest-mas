// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:masbar/core/constants/api_constants.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../models/promotion_model.dart';

abstract class PromotionDataSource {
  Future<List<PromotionModel>> getPromotions();
  Future<PromotionModel> getPromotionDetails({required int id});
  Future<void> createPromotionDetails({
    required String promo,
    required num discount,
    required DateTime expiration,
    required List<int> services,
  });
  Future<void> updatePromotionDetails({
    required int promoId,
    required String promo,
    required num discount,
    required DateTime expiration,

  });
  Future<void> deletePromotionDetails({
    required int promoId,
  });
  Future<void> assignServiceToPromo({
    required int promoId,
    required int serviceId,
  });
  Future<void> removeServiceFromPromo({
    required int promoId,
    required int serviceId,
  });
}

class PromotionDataSourceWithHttp implements PromotionDataSource {
  final BaseApiService client;
  PromotionDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<void> createPromotionDetails(
      {required String promo,
      required num discount,
      required DateTime expiration,
      required List<int> services}) async {
    final res =
        await client.postRequest(url: ApiConstants.createPromo, jsonBody: {
      "promo_code": promo,
      "discount": discount,
      "expiration": expiration.toString(),
      "service": services.map((e) => e).toList()
    });
    return;
  }

  @override
  Future<void> deletePromotionDetails({required int promoId}) async {
    final res = await client.getRequest(
      url: ApiConstants.deletePromo + '/$promoId',
    );
  }

  @override
  Future<PromotionModel> getPromotionDetails({required int id}) async {
    final res = await client.getRequest(
        url: ApiConstants.viewPromotionDetails + '/$id');
    return PromotionModel.fromJson(res);
  }

  @override
  Future<List<PromotionModel>> getPromotions() async {
    final res = await client.getRequest(url: ApiConstants.getPromotionList);
    List<PromotionModel> data = [];
    for (var element in res['List']) {
      data.add(PromotionModel.fromJson(element));
    }
    return data;
  }

  @override
  Future<void> updatePromotionDetails(
      {required int promoId,
      required String promo,
      required num discount,
      required DateTime expiration,
    }) async {
    final res = await client
        .postRequest(url: '${ApiConstants.updatePromo}/$promoId', jsonBody: {
      "promo_code": promo,
      "discount": discount,
      "expiration": expiration.toString(),
      // "service": services.map((e) => e).toList()
    });
    return;
  }

  @override
  Future<void> assignServiceToPromo(
      {required int promoId, required int serviceId}) async {
    final res = await client.postRequest(
      url: ApiConstants.assignServiceToPromo,
      jsonBody: {
        "promocode_id": promoId,
        "service_id": serviceId,
      },
    );
    return;
  }

  @override
  Future<void> removeServiceFromPromo(
      {required int promoId, required int serviceId}) async {
    final res = await client.postRequest(
      url: ApiConstants.removeServiceFromPromo,
      jsonBody: {
        "promocode_id": promoId,
        "service_id": serviceId,
      },
    );
    return;
  }
}
