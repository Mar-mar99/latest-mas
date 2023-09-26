import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/errors/exceptions.dart';
import 'package:masbar/core/utils/enums/enums.dart';

import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/utils/helpers/decode_response.dart';
import 'package:http/http.dart' as http;

abstract class ForgetPasswordDataSource {
  Future<int> sendEmail({
    required String email,
    required TypeAuth typeAuth,
  });
  Future<void> submitNewPassword({
    required int id,
    required String password,
    required String confirmPassword,
    required String otp,
    required TypeAuth typeAuth,
  });
}

class ForgetPasswordDataSourceWithHttp implements ForgetPasswordDataSource {
  final BaseApiService client;
  ForgetPasswordDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<int> sendEmail(
      {required String email, required TypeAuth typeAuth}) async {
    var link = typeAuth == TypeAuth.user
        ? ApiConstants.sendPasswordResetCode
        : ApiConstants.forgotCompanies;

    final res = await client.postRequest(
      url: link,
      jsonBody: {
        "email": email,
      },
    );
    int id = res['id'] ?? res['user']['id'];
    return id;
  }

  @override
  Future<void> submitNewPassword({
    required int id,
    required String password,
    required String confirmPassword,
    required String otp,
    required TypeAuth typeAuth,
  }) async {
    var link = typeAuth == TypeAuth.user
        ? ApiConstants.userResetPassword
        : ApiConstants.resetPasswordCompaniesAPI;
    final res = await client.postRequest(url: link, jsonBody: {
      "id": id,
      "password": password,
      "password_confirmation": confirmPassword,
      "otp": otp,
    });
    return;
  }
}
