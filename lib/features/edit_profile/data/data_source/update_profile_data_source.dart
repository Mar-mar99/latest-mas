// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/api_service/base_api_service.dart';

abstract class UpdateProfileDataSource {
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  });
  Future<void> updateCompanyProfile({
    required String firstName,
    required String address,
    required int local,
    required int state,
    File? avatar,
  });
  Future<void> updateProviderProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  });
  Future<void> updateUserPhone({
    required String phone,
    required TypeAuth typeAuth,
  });
  Future<void> verifyUserPhone({
    required String phone,
    required String phoneCode,
    required TypeAuth typeAuth,
  });
}

class UpdateProfileDataSourceWithHttp extends UpdateProfileDataSource {
  final BaseApiService client;
  UpdateProfileDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required int state,
    File? avatar,
  }) async {
    final data = await client.multipartRequest(
      attributeName: avatar != null ? 'picture' : null,
      files: avatar != null ? [avatar] : null,
      url: ApiConstants.updateProfileAPI,
      jsonBody: {
        'first_name': firstName,
        'last_name': lastName,
        'state': state,
      },
    );

    return;
  }

  @override
  Future<void> updateUserPhone(
      {required String phone, required TypeAuth typeAuth}) async {
    var link = '';
    switch (typeAuth) {
      case TypeAuth.user:
        link = ApiConstants.updateUserPhoneAPI;
        break;
      case TypeAuth.company:
        link = ApiConstants.updateCompanyPhoneAPI;
        break;
      case TypeAuth.provider:
        link = ApiConstants.updateProviderPhoneAPI;
        break;
    }
    final data = await client.postRequest(
      url: link,
      jsonBody: {
        'mobile': phone,
        'phone_code': '+971',
      },
    );

    return;
  }

  @override
  Future<void> updateCompanyProfile({
    required String firstName,
    required String address,
    required int local,
    required int state,
    File? avatar,
  }) async {
    print('company profile data source');
    final data = await client.multipartRequest(
      attributeName: avatar != null ? 'avatar' : null,
      files: avatar != null ? [avatar] : null,
      url: ApiConstants.updateProfileCompaniesAPI,
      jsonBody: {
        'first_name': firstName,
        'address': address,
        'local': local,
        'state': state,
      },
    );

    return;
  }

  @override
  Future<void> updateProviderProfile(
      {required String firstName,
      required String lastName,
      required int state,
      File? avatar}) async {
    final data = await client.multipartRequest(
      attributeName: avatar != null ? 'avatar' : null,
      files: avatar != null ? [avatar] : null,
      url: ApiConstants.providerProfileUpdate,
      jsonBody: {
        'first_name': firstName,
        'last_name': lastName,
        'state': state,
      },
    );

    return;
  }

  @override
  Future<void> verifyUserPhone({
    required String phone,
    required String phoneCode,
    required TypeAuth typeAuth,
  }) async {
    var link = '';
    switch (typeAuth) {
      case TypeAuth.user:
        link = ApiConstants.verifyUserPhoneAPI;
        break;
      case TypeAuth.company:
        link = ApiConstants.verifyCompanyPhoneAPI;
        break;
      case TypeAuth.provider:
        link = ApiConstants.verifyProviderPhoneAPI;
        break;
    }
    final data = await client.postRequest(
      url: link,
      jsonBody: {
        'mobile': phone,
        'otp': phoneCode,
        'phone_code': '+971',
      },
    );

    return;
  }
}
