// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';

import '../model/service_price_model.dart';

abstract class ServicePricesDataSource {

  Future<List<ServicePriceModel>> getPrices({required int id});
  Future<void> updatePrices({
    required int serviceId,
    required int stateId,
    required double fixed,
    required double hourly,
  });
}

class ServicePricesDataSourceWithHttp implements ServicePricesDataSource {
  final BaseApiService client;
  ServicePricesDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<ServicePriceModel>> getPrices({required int id}) async {
    final res = await client.getRequest(
      url: ApiConstants.getcompanyServicesPrices + '/$id',
    );
    List<ServicePriceModel> data = [];

    res['Prices'].forEach((element) {
      data.add(ServicePriceModel.fromJson(element));
    });
    return data;
  }

  @override
  Future<void> updatePrices({
    required int serviceId,
    required int stateId,
    required double fixed,
    required double hourly,
  }) async {
    final res = await client.postRequest(
        url: ApiConstants.updatecompanyServicesPrices + '/$serviceId',
        jsonBody: {
          "Prices": [
            {"state_id": stateId, "fixed_price": fixed, "hourly_price": hourly}
          ]
        });

    return;
  }
}
