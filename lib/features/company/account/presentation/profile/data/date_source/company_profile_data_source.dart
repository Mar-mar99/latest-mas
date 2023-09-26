// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../../../core/api_service/base_api_service.dart';
import '../../../../../../../core/constants/api_constants.dart';
import '../model/company_emirates_model.dart';

abstract class CompanyProfileDataSource {
   Future<List<CompanyEmiratesModel>> getCompanyEmirates();
  Future<void> updateCompanyEmirates(
      {required List<int> states, required int headState});
  Future<void> updateAddress({
    required String address,
  });
}

class CompanyProfileDataSourceWithHttp implements CompanyProfileDataSource {
  final BaseApiService client;
  CompanyProfileDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<List<CompanyEmiratesModel>> getCompanyEmirates() async {
    final res = await client.getRequest(
      url: ApiConstants.companyStates,
    );
    List<CompanyEmiratesModel> data = [];

    res['states'].forEach((element) {
      data.add(CompanyEmiratesModel.fromJson(element));
    });
    return data;
  }

  @override
  Future<void> updateCompanyEmirates(
      {required List<int> states, required int headState}) async {
    final res = await client.postRequest(
        url: ApiConstants.updateCompanyStates,
        jsonBody: {
          "state": states.map((e) => e).toList(),
          "mainBranch": headState
        });

    return;
  }

  @override
  Future<void> updateAddress({required String address}) async {
    final res = await client.postRequest(
        url: ApiConstants.updateCompanyAddress, jsonBody: {"address": address});

    return;
  }
}
