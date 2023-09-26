import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/summary_earnings_company_model.dart';

abstract class CompanyEarningsSummaryDataSource {
  Future<SummaryEarningsCompanyModel> getTodaySummary(
      {required String? providerId});
  Future<SummaryEarningsCompanyModel> getRangeSummary(
      {required DateTime start, required DateTime end, String? providerId});
}

class CompanyEarningsSummaryDataSourceWithHttp
    implements CompanyEarningsSummaryDataSource {
  final BaseApiService client;
  CompanyEarningsSummaryDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<SummaryEarningsCompanyModel> getTodaySummary(
      {required String? providerId}) async {
    final res = await client.postRequest(
      url: ApiConstants.companiesEarningDaily,
      jsonBody: {
        'date':
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      if (providerId != null) 'provider_id': providerId
      },
    );
    return SummaryEarningsCompanyModel.fromJson(res);
  }

  @override
  Future<SummaryEarningsCompanyModel> getRangeSummary(
      {required DateTime start,
      required DateTime end,
      String? providerId}) async {
    final res = await client.postRequest(
      url: ApiConstants.companiesEarningPeriod,
      jsonBody: {
        'fromDate': '${start.year}-${start.month}-${start.day}',
        'toDate': '${end.year}-${end.month}-${end.day}',
        if (providerId != null) 'provider_id': providerId
      },
    );
    return SummaryEarningsCompanyModel.fromJson(res);
  }
}
