import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/request_past_provider_model.dart';
import '../model/request_upcoming_provider_model.dart';

abstract class ServiceRecordeProviderDataSource {
  Future<List<RequestPastProviderModel>> getRequestsHistoryProvider(
      {required int page});

  Future<List<RequestUpcomingProviderModel>> getRequestsUpcomingProvider(
      {required int page});

  Future<void> rate({
    required int rating,
    required int requestId,
    String comment = '',
  });
}

class ServiceRecordeProviderDataSourceWithHttp
    implements ServiceRecordeProviderDataSource {
  final BaseApiService client;
  ServiceRecordeProviderDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<List<RequestPastProviderModel>> getRequestsHistoryProvider({
    required int page,
  }) async {
    print('hi: ${ApiConstants.providerRequestsPast}?page=$page');
    final res = await client.getRequest(
        url: "${ApiConstants.providerRequestsPast}?page=$page");
    List<RequestPastProviderModel> data = [];
    res['data'].forEach((c) {
      data.add(RequestPastProviderModel.fromJson(c));
    });
    return data;
  }

  @override
  Future<List<RequestUpcomingProviderModel>> getRequestsUpcomingProvider(
      {required int page}) async {
        print('hjeeee ${ApiConstants.providerRequestsUpcoming}?page=$page}' );
    final res = await client.getRequest(
        url: "${ApiConstants.providerRequestsUpcoming}?page=$page");
    List<RequestUpcomingProviderModel> data = [];
    res['data'].forEach((c) {
      data.add(RequestUpcomingProviderModel.fromJson(c));
    });
    return data;
  }

  @override
  Future<void> rate(
      {required int rating,
      required int requestId,
      String comment = ''}) async {
    final res = await client.postRequest(
      url: ApiConstants.providerRate,
      jsonBody: {
        "request_id": requestId,
        "rating": rating,
        "comment": comment,
      },
    );

    return;
  }
}
