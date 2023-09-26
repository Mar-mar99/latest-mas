// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:masbar/core/constants/api_constants.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/helpers/decode_response.dart';

abstract class VerifyAccountDataSource {
  Future<void> verifyAccount({
    required String otp,
    required TypeAuth auth,
  });
  Future<void> resendCode({
    required TypeAuth auth,
  });
}

class VerifyAccoutnDataSourceWithHttp extends VerifyAccountDataSource {
  final BaseApiService client;
  VerifyAccoutnDataSourceWithHttp({
    required this.client,
  });

  @override
  Future<void> resendCode({
    required TypeAuth auth,
  }) async {
    var link = '';
    switch (auth) {
      case TypeAuth.user:
        link =
            '${ApiConstants.resendVerificationCodeViaEmail}';
        break;
      case TypeAuth.company:
        link =
            '${ApiConstants.resendVerificationCodeViaEmailCompany}';
        break;
      case TypeAuth.provider:
        link =
            '${ApiConstants.resendVerificationCodeViaEmailProvider}';
        break;
    }

    final response = await client.postRequest(url: link, jsonBody: {});
  }

  @override
  Future<void> verifyAccount({
    required String otp,
    required TypeAuth auth,
  }) async {
    var link = '';
    switch (auth) {
      case TypeAuth.user:
        link = '${ApiConstants.verifyEmail}';
        break;
      case TypeAuth.company:
        link = '${ApiConstants.verifyEmailCompany}';
        break;
      case TypeAuth.provider:
        link = '${ApiConstants.verifyEmailProvider}';
        break;
    }
    await client.postRequest(url: link, jsonBody: {
      "otp": otp,
    });
  }
}
