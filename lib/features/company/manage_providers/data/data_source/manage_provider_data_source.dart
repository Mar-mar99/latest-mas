// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:masbar/core/constants/api_constants.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../model/provider_info_model.dart';
import '../model/provider_model.dart';

abstract class ManageProvidersDataSource {
  Future<ProviderInfoModel> getProvidersInfo();
  Future<List<ProviderModel>> searchActiveProviders({required String key});
  Future<List<ProviderModel>> getPending();
  Future<void> invite({
    required String firstname,
    required String lastname,
    required String mobile,
    required int state,
  });
  Future<void> enableUser({required int id});
  Future<void> disableUser({required int id});
  Future<void> reSendInvitations({required int id});
  Future<void> deleteInvitation({required int id});
}

class ManageProvidersDataSourceWithHttp extends ManageProvidersDataSource {
  final BaseApiService client;
  ManageProvidersDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<void> disableUser({required int id}) async {
    final data = await client.getRequest(
      url: '${ApiConstants.enableUserManageProviders}$id',
    );

    return;
  }

  @override
  Future<void> enableUser({required int id}) async {
    final data = await client.getRequest(
      url: '${ApiConstants.enableUserManageProviders}$id',
    );

    return;
  }

  @override
  Future<List<ProviderModel>> getPending() async {
    final data = await client.postRequest(
        url: ApiConstants.getInvitationsManageProviders, jsonBody: {});
    List<ProviderModel> providers = [];
    data.forEach((c) {
      providers.add(ProviderModel.fromJson(c));
    });
    return providers;
  }

  @override
  Future<ProviderInfoModel> getProvidersInfo() async {
    final data = await client.getRequest(
      url: ApiConstants.getInfoManageProviders,
    );
    return ProviderInfoModel.fromJson(data);
  }

  @override
  Future<void> invite(
      {required String firstname,
      required String lastname,
      required String mobile,
      required int state}) async {
    final data = await client.postRequest(
      url: ApiConstants.invitationManageProviders,
      jsonBody: {
        "first_name": firstname,
        "last_name": lastname,
        "mobile": mobile,
        "state": state,
      },
    );

    return;
  }

  @override
  Future<void> deleteInvitation({required int id}) async {
    final data = await client.getRequest(
      url: '${ApiConstants.deleteInvitationsManageProviders}$id',
    );

    return;
  }

  @override
  Future<void> reSendInvitations({required int id}) async {
    final data = await client.getRequest(
      url: '${ApiConstants.reSendInvitationsManageProviders}$id',
    );

    return;
  }

  @override
  Future<List<ProviderModel>> searchActiveProviders({required String key}) async {
    final data = await client.postRequest(
      url: ApiConstants.searchManageProviders,
      jsonBody: {
        'searchFor': key,
      },
    );
    List<ProviderModel> providers = [];
    data.forEach((c) {
      providers.add(ProviderModel.fromJson(c));
    });
    return providers;
  }
}
