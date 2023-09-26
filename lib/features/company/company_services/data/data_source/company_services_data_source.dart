import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/company_service_model.dart';

abstract class CompanyServicesDataSource{
  Future<List<CompanyServiceModel>> getCompanyServices();
}


class CompanyServicesDataSourceWithHttp implements CompanyServicesDataSource {
  final BaseApiService client;
  CompanyServicesDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<List<CompanyServiceModel>> getCompanyServices() async {
    final res = await client.getRequest(
      url: ApiConstants.companyServices,
    );
    List<CompanyServiceModel> data = [];

    res['List'].forEach((element) {
      data.add(CompanyServiceModel.fromJson(element));
    });
    return data;
  }


}
