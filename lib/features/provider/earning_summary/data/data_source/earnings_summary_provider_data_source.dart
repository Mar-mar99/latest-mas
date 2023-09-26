
import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/summary_earnings_provider_model.dart';

abstract class EarningsSummaryDataSource {
  Future<SummaryEarningsProviderModel> getTodaySummary();
  Future<SummaryEarningsProviderModel> getRangeSummary({
    required DateTime start,
    required DateTime end,
  });
}

class EarningsSummaryDataSourceWithHttp implements EarningsSummaryDataSource {
  final BaseApiService client;
  EarningsSummaryDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<SummaryEarningsProviderModel> getTodaySummary() async {
    final res = await client
        .postRequest(url: ApiConstants.providerEarningDaily, jsonBody: {
      'date':
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
    });
    return SummaryEarningsProviderModel.fromJson(res);
  }

  @override
  Future<SummaryEarningsProviderModel> getRangeSummary({
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await client
        .postRequest(url: ApiConstants.providerEarningPeriod, jsonBody: {
      'fromDate': '${start.year}-${start.month}-${start.day}',
      'toDate': '${end.year}-${end.month}-${end.day}',
    });
    return SummaryEarningsProviderModel.fromJson(res);
  }
}
